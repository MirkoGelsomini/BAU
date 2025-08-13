// tests/controllers/feedbackController.test.js
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
        it('ritorna 400 se manca transactionId', () => {
            req.body = { comment: 'Ottimo lavoro' }
            receiveFeedback(req, res, next)
            expect(res.status).toHaveBeenCalledWith(400)
            expect(res.json).toHaveBeenCalledWith({ error: 'Missing transactionId' })
            expect(next).not.toHaveBeenCalled()
        })

        it('imposta req.transactionId e req.feedback e chiama next()', () => {
            req.body = { transactionId: 'abc123', comment: 'Ottimo lavoro', rating: 5 }
            receiveFeedback(req, res, next)
            expect(req.transactionId).toBe('abc123')
            expect(req.feedback).toEqual({ comment: 'Ottimo lavoro', rating: 5 })
            expect(next).toHaveBeenCalled()
        })
    })

    describe('sendFeedbackResponse', () => {
        it('salva feedback e invia risposta', async () => {
            req.transactionId = 'abc123'
            req.feedback = { comment: 'Ottimo lavoro', rating: 5 }

            saveController.saveFileFeedback.mockResolvedValue()
            saveController.saveFileDefinitive.mockResolvedValue()

            await sendFeedbackResponse(req, res)

            expect(saveController.saveFileFeedback).toHaveBeenCalledWith('abc123', { comment: 'Ottimo lavoro', rating: 5 })
            expect(saveController.saveFileDefinitive).toHaveBeenCalledWith('abc123')
            expect(res.json).toHaveBeenCalledWith({
                message: 'Feedback successfully received',
                feedback: { comment: 'Ottimo lavoro', rating: 5 },
                transactionId: 'abc123'
            })
        })
    })
})
