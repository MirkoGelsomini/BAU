import { describe, it, expect, vi, beforeEach } from 'vitest'
import * as authController from '../../src/controllers/authController.js'
import * as database from '../../src/models/database.js'
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'

vi.mock('../../src/models/database.js')
vi.mock('bcrypt')
vi.mock('jsonwebtoken')

describe('Auth Controller - createAccount', () => {
    let req, res

    beforeEach(() => {
        req = {
            body: {
                username: 'testuser',
                password: 'password123',
                firstName: 'Test',
                lastName: 'User',
                age: 25,
                country: 'Italy'
            }
        }

        res = {
            status: vi.fn(() => res),
            json: vi.fn()
        }
    })

    it('should return 400 if any required field is missing', async () => {
        req.body = {} // missing all fields
        await authController.createAccount(req, res)
        expect(res.status).toHaveBeenCalledWith(400)
        expect(res.json).toHaveBeenCalledWith({ success: false, message: 'All fields are required' })
    })

    it('should create user and return token on success', async () => {
        bcrypt.hash.mockResolvedValue('hashed_password')
        database.createUser.mockResolvedValue({
            id: 1,
            username: 'testuser',
            firstName: 'Test',
            lastName: 'User',
            age: 25,
            country: 'Italy'
        })
        jwt.sign.mockReturnValue('fake_jwt_token')

        await authController.createAccount(req, res)

        expect(bcrypt.hash).toHaveBeenCalledWith('password123', 10)
        expect(database.createUser).toHaveBeenCalled()
        expect(jwt.sign).toHaveBeenCalledWith({ username: 'testuser' }, expect.any(String), { expiresIn: '1d' })
        expect(res.status).toHaveBeenCalledWith(201)
        expect(res.json).toHaveBeenCalledWith({
            success: true,
            user: expect.objectContaining({ username: 'testuser' }),
            token: 'fake_jwt_token'
        })
    })

    it('should return 400 if username already exists', async () => {
        bcrypt.hash.mockResolvedValue('hashed_password')
        database.createUser.mockRejectedValue(new Error('Username already exists'))

        await authController.createAccount(req, res)

        expect(res.status).toHaveBeenCalledWith(400)
        expect(res.json).toHaveBeenCalledWith({ success: false, message: 'Username already exists' })
    })

    it('should return 500 on other errors', async () => {
        bcrypt.hash.mockResolvedValue('hashed_password')
        database.createUser.mockRejectedValue(new Error('Unknown error'))

        await authController.createAccount(req, res)

        expect(res.status).toHaveBeenCalledWith(500)
        expect(res.json).toHaveBeenCalledWith(expect.objectContaining({ success: false, message: 'Server error' }))
    })
})

describe('Auth Controller - login', () => {
    let req, res

    beforeEach(() => {
        req = {
            body: {
                username: 'testuser',
                password: 'password123'
            }
        }

        res = {
            status: vi.fn(() => res),
            json: vi.fn()
        }
    })

    it('should return 400 if username or password is missing', async () => {
        req.body = {} // missing both
        await authController.login(req, res)
        expect(res.status).toHaveBeenCalledWith(400)
        expect(res.json).toHaveBeenCalledWith({ message: 'Username and password are required' })
    })

    it('should return 401 if user does not exist', async () => {
        database.findUserByUsername.mockResolvedValue([])

        await authController.login(req, res)

        expect(database.findUserByUsername).toHaveBeenCalledWith('testuser')
        expect(res.status).toHaveBeenCalledWith(401)
        expect(res.json).toHaveBeenCalledWith({ message: 'Invalid credentials' })
    })

    it('should return 401 if password is incorrect', async () => {
        const fakeUser = { id: 1, username: 'testuser', password: 'hashed_password' }
        database.findUserByUsername.mockResolvedValue([fakeUser])
        bcrypt.compare.mockResolvedValue(false)

        await authController.login(req, res)

        expect(bcrypt.compare).toHaveBeenCalledWith('password123', 'hashed_password')
        expect(res.status).toHaveBeenCalledWith(401)
        expect(res.json).toHaveBeenCalledWith({ message: 'Invalid credentials' })
    })

    it('should return token and user info on successful login', async () => {
        const fakeUser = {
            id: 1,
            username: 'testuser',
            password: 'hashed_password',
            firstName: 'Test',
            lastName: 'User',
            age: 25,
            country: 'Italy',
            email: 'test@example.com'
        }
        database.findUserByUsername.mockResolvedValue([fakeUser])
        bcrypt.compare.mockResolvedValue(true)
        jwt.sign.mockReturnValue('fake_jwt_token')

        await authController.login(req, res)

        expect(res.json).toHaveBeenCalledWith({
            token: 'fake_jwt_token',
            user: {
                id: 1,
                username: 'testuser',
                firstName: 'Test',
                lastName: 'User',
                age: 25,
                country: 'Italy',
                email: 'test@example.com'
            }
        })
    })

    it('should return 500 on server error', async () => {
        database.findUserByUsername.mockRejectedValue(new Error('DB error'))

        await authController.login(req, res)

        expect(res.status).toHaveBeenCalledWith(500)
        expect(res.json).toHaveBeenCalledWith({ message: 'Server error' })
    })
})
