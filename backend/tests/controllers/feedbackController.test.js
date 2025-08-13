import { describe, it, expect, vi, beforeEach } from 'vitest'
import { receiveFeedback, sendFeedbackResponse } from '../../src/controllers/feedbackController.js'
import * as saveController from '../../src/controllers/saveController.js'

vi.mock('../../src/controllers/saveController.js')

describe('Feedback Controller', () => {
    let req, res, next

    beforeEach(() => {
        req = { body: {}, transactionId: null, feedback: null }
        res = {
            status: vi.fn(() => res),
            json: vi.fn()
        }
        next = vi.fn()
        vi.clearAllMocks()
    })

    describe('receiveFeedback', () => {
        it('returns 400 if transactionId is missing', () => {
            req.body = { comment: 'Great work' }
            receiveFeedback(req, res, next)
            expect(res.status).toHaveBeenCalledWith(400)
            expect(res.json).toHaveBeenCalledWith({ error: 'Missing transactionId' })
            expect(next).not.toHaveBeenCalled()
        })

        it('sets req.transactionId and req.feedback and calls next()', () => {
            req.body = { transactionId: 'abc123', comment: 'Great work', rating: 5 }
            receiveFeedback(req, res, next)
            expect(req.transactionId).toBe('abc123')
            expect(req.feedback).toEqual({ comment: 'Great work', rating: 5 })
            expect(next).toHaveBeenCalled()
        })
    })

    describe('sendFeedbackResponse', () => {
        it('saves feedback and sends response', async () => {
            req.transactionId = 'abc123'
            req.feedback = { comment: 'Great work', rating: 5 }

            saveController.saveFileFeedback.mockResolvedValue()
            saveController.saveFileDefinitive.mockResolvedValue()

            await sendFeedbackResponse(req, res)

            expect(saveController.saveFileFeedback).toHaveBeenCalledWith('abc123', { comment: 'Great work', rating: 5 })
            expect(saveController.saveFileDefinitive).toHaveBeenCalledWith('abc123')
            expect(res.json).toHaveBeenCalledWith({
                message: 'Feedback successfully received',
                feedback: { comment: 'Great work', rating: 5 },
                transactionId: 'abc123'
            })
        })
    })
})
