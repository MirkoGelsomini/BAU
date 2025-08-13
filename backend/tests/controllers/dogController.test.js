import { describe, it, expect, vi, beforeEach } from 'vitest'
import * as dogsController from '../../src/controllers/dogController.js'
import * as database from '../../src/models/database.js'

vi.mock('../../src/models/database.js')

describe('Dogs Controller', () => {
    let req, res

    beforeEach(() => {
        req = { body: {}, query: {} }
        res = {
            status: vi.fn(() => res),
            json: vi.fn()
        }
        vi.clearAllMocks()
    })

    // ADD DOG
    describe('addDog', () => {
        it('should return 400 if userId or name is missing', async () => {
            req.body = { userId: 1 }
            await dogsController.addDog(req, res)
            expect(res.status).toHaveBeenCalledWith(400)
        })

        it('should create dog and return 201', async () => {
            req.body = {
                userId: 1,
                name: 'Fido',
                breed: 'Labrador',
                birthDate: '2020-01-01T00:00:00Z',
                gender: 'Male',
                weight: 25
            }
            database.addDog.mockResolvedValue({ id: 1, name: 'Fido' })

            await dogsController.addDog(req, res)

            expect(database.addDog).toHaveBeenCalledWith(
                1,
                'Fido',
                'Labrador',
                '2020-01-01',
                'Male',
                25
            )
            expect(res.status).toHaveBeenCalledWith(201)
        })

        it('should return 500 if database throws', async () => {
            req.body = {
                userId: 1,
                name: 'Fido',
                birthDate: '2020-01-01T00:00:00Z'
            }
            database.addDog.mockRejectedValue(new Error('DB error'))

            await dogsController.addDog(req, res)

            expect(res.status).toHaveBeenCalledWith(500)
        })
    })

    // GET DOGS
    describe('getDogs', () => {
        it('should return 400 if userId is missing', async () => {
            await dogsController.getDogs(req, res)
            expect(res.status).toHaveBeenCalledWith(400)
        })

        it('should return dogs on success', async () => {
            req.query.userId = 1
            database.getDogsByUserId.mockResolvedValue([{ id: 1, name: 'Fido' }])

            await dogsController.getDogs(req, res)

            expect(res.json).toHaveBeenCalledWith({ success: true, dogs: [{ id: 1, name: 'Fido' }] })
        })
    })

    // EDIT DOG
    describe('editDog', () => {
        it('should return 400 if userId or id is missing', async () => {
            req.body = { userId: 1 }
            await dogsController.editDog(req, res)
            expect(res.status).toHaveBeenCalledWith(400)
        })

        it('should return 404 if dog not found for user', async () => {
            req.body = { id: 1, userId: 1 }
            database.getDogsByUserId.mockResolvedValue([])

            await dogsController.editDog(req, res)

            expect(res.status).toHaveBeenCalledWith(404)
        })

        it('should update dog if found', async () => {
            req.body = { id: 1, userId: 1, name: 'NewName' }
            database.getDogsByUserId.mockResolvedValue([{ id: 1, name: 'OldName' }])
            database.editDog.mockResolvedValue({ id: 1, name: 'NewName' })

            await dogsController.editDog(req, res)

            expect(res.json).toHaveBeenCalledWith({ success: true, dog: { id: 1, name: 'NewName' } })
        })
    })

    // DELETE DOG
    describe('deleteDog', () => {
        it('should return 400 if userId or dogId is missing', async () => {
            await dogsController.deleteDog(req, res)
            expect(res.status).toHaveBeenCalledWith(400)
        })

        it('should return 404 if delete fails', async () => {
            req.query = { userId: 1, dogId: 2 }
            database.deleteDog.mockResolvedValue({ success: false, message: 'Dog not found' })

            await dogsController.deleteDog(req, res)

            expect(res.status).toHaveBeenCalledWith(404)
        })

        it('should delete dog on success', async () => {
            req.query = { userId: 1, dogId: 2 }
            database.deleteDog.mockResolvedValue({ success: true })

            await dogsController.deleteDog(req, res)

            expect(res.json).toHaveBeenCalledWith({ success: true })
        })
    })
})
