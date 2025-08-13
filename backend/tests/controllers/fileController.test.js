import { describe, it, expect, vi, beforeEach } from 'vitest'
import { receiveFile } from '../../src/controllers/fileController.js'

describe('receiveFile middleware', () => {
    let req, res, next

    beforeEach(() => {
        req = {}
        res = {
            status: vi.fn(() => res),
            json: vi.fn()
        }
        next = vi.fn()
    })

    it('should return 400 if no file is received', () => {
        req.file = undefined

        receiveFile(req, res, next)

        expect(res.status).toHaveBeenCalledWith(400)
        expect(res.json).toHaveBeenCalledWith({ error: 'No file received' })
        expect(next).not.toHaveBeenCalled()
    })

    it('should attach file to req.audioFile and call next', () => {
        const mockFile = { originalname: 'test.mp3', buffer: Buffer.from('fake audio') }
        req.file = mockFile

        receiveFile(req, res, next)

        expect(req.audioFile).toBe(mockFile)
        expect(next).toHaveBeenCalled()
        expect(res.status).not.toHaveBeenCalled()
    })
})
