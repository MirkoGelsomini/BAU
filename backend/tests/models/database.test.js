import { describe, it, expect, beforeEach, vi } from 'vitest'
import * as db from '../../src/models/database.js'

describe('database module', () => {
    beforeEach(() => {
        db.default.query = vi.fn()
    })

    describe('saveAudioDetails', () => {
        it('should save audio details and return insertId', async () => {
            db.default.query.mockResolvedValue([{ insertId: 42 }])
            const id = await db.saveAudioDetails('path/to/audio.mp3', 'bulldog')

            expect(db.default.query).toHaveBeenCalledWith(
                expect.stringContaining('INSERT INTO audio_predictions'),
                ['path/to/audio.mp3', 'bulldog']
            )
            expect(id).toBe(42)
        })
    })

    describe('getAllAudioDetails', () => {
        it('should log first row if exists', async () => {
            const consoleSpy = vi.spyOn(console, 'log').mockImplementation(() => {})
            db.default.query.mockResolvedValue([[{ id: 1, audio_path: 'a.mp3' }]])
            await db.getAllAudioDetails()
            expect(consoleSpy).toHaveBeenCalledWith({ id: 1, audio_path: 'a.mp3' })
            consoleSpy.mockRestore()
        })

        it('should log no data message if empty', async () => {
            const consoleSpy = vi.spyOn(console, 'log').mockImplementation(() => {})
            db.default.query.mockResolvedValue([[]])
            await db.getAllAudioDetails()
            expect(consoleSpy).toHaveBeenCalledWith('No data found in audio_analysis table.')
            consoleSpy.mockRestore()
        })
    })

    describe('getAudioDetailById', () => {
        it('should log audio detail if found', async () => {
            const consoleSpy = vi.spyOn(console, 'log').mockImplementation(() => {})
            db.default.query.mockResolvedValue([[{ id: 5, audio_path: 'file.mp3' }]])
            await db.getAudioDetailById(5)
            expect(consoleSpy).toHaveBeenCalledWith({ id: 5, audio_path: 'file.mp3' })
            consoleSpy.mockRestore()
        })

        it('should log not found message if no audio', async () => {
            const consoleSpy = vi.spyOn(console, 'log').mockImplementation(() => {})
            db.default.query.mockResolvedValue([[]])
            await db.getAudioDetailById(5)
            expect(consoleSpy).toHaveBeenCalledWith('No audio found with id 5')
            consoleSpy.mockRestore()
        })
    })

    describe('addAudioPrediction', () => {
        it('should insert predictions and update audio_predictions', async () => {
            db.default.query
                .mockResolvedValueOnce([{ insertId: 100 }])
                .mockResolvedValueOnce([{ affectedRows: 1 }])

            const predictions = [
                { label: 'breed1', confidence: 0.9 },
                { label: 'breed2', confidence: 0.05 },
                { label: 'breed3', confidence: 0.03 },
            ]

            await db.addAudioPrediction(1, predictions)

            expect(db.default.query).toHaveBeenNthCalledWith(
                1,
                expect.stringContaining('INSERT INTO predictions'),
                ['breed1', 0.9, 'breed2', 0.05, 'breed3', 0.03]
            )
            expect(db.default.query).toHaveBeenNthCalledWith(
                2,
                expect.stringContaining('UPDATE audio_predictions'),
                [100, 1]
            )
        })
    })

    describe('saveAudioFeedback', () => {
        it('should insert feedback and update audio_predictions', async () => {
            db.default.query
                .mockResolvedValueOnce([{ insertId: 55 }])
                .mockResolvedValueOnce([{ affectedRows: 1 }])

            await db.saveAudioFeedback(3, true, 'bulldog', 'Nice prediction')

            expect(db.default.query).toHaveBeenNthCalledWith(
                1,
                expect.stringContaining('INSERT INTO feedbacks'),
                [true, 'bulldog', 'Nice prediction']
            )
            expect(db.default.query).toHaveBeenNthCalledWith(
                2,
                expect.stringContaining('UPDATE audio_predictions'),
                [55, 3]
            )
        })
    })

    describe('getCorrectCategory', () => {
        it('should return correct label if exists', async () => {
            db.default.query.mockResolvedValue([[{ correct_label: 'bulldog' }]])
            const label = await db.getCorrectCategory(10)
            expect(label).toBe('bulldog')
            expect(db.default.query).toHaveBeenCalledWith(expect.any(String), [10])
        })

        it('should return null if no rows', async () => {
            db.default.query.mockResolvedValue([[]])
            const label = await db.getCorrectCategory(10)
            expect(label).toBeNull()
        })
    })

    describe('getAudioPath', () => {
        it('should return audio path if found', async () => {
            db.default.query.mockResolvedValue([[{ audio_path: 'audio.mp3' }]])
            const path = await db.getAudioPath(7)
            expect(path).toBe('audio.mp3')
        })

        it('should throw if not found', async () => {
            db.default.query.mockResolvedValue([[]])
            await expect(db.getAudioPath(7)).rejects.toThrow('No audio found with id 7')
        })
    })

    describe('getDogBreed', () => {
        it('should return dog breed if found', async () => {
            db.default.query.mockResolvedValue([[{ dog_breed: 'bulldog' }]])
            const breed = await db.getDogBreed(9)
            expect(breed).toBe('bulldog')
        })

        it('should throw if not found', async () => {
            db.default.query.mockResolvedValue([[]])
            await expect(db.getDogBreed(9)).rejects.toThrow('No file found with id 9')
        })
    })

    describe('updateAudioPath', () => {
        it('should update audio path if record exists', async () => {
            db.default.query.mockResolvedValue([{ affectedRows: 1 }])
            await db.updateAudioPath(8, 'new/path.mp3')
            expect(db.default.query).toHaveBeenCalledWith(
                expect.stringContaining('UPDATE audio_predictions'),
                ['new/path.mp3', 8]
            )
        })

        it('should throw if no rows affected', async () => {
            db.default.query.mockResolvedValue([{ affectedRows: 0 }])
            await expect(db.updateAudioPath(8, 'new/path.mp3')).rejects.toThrow(
                'No record updated. ID 8 not found.'
            )
        })
    })

    describe('createUser', () => {
        it('should create user successfully', async () => {
            db.default.query.mockResolvedValue([{ insertId: 101 }])
            const user = await db.createUser('user1', 'hash', 'First', 'Last', 30, 'IT')

            expect(user).toEqual({
                id: 101,
                username: 'user1',
                firstName: 'First',
                lastName: 'Last',
                age: 30,
                country: 'IT',
            })
        })

        it('should throw if username exists', async () => {
            db.default.query.mockRejectedValue({ code: 'ER_DUP_ENTRY' })
            await expect(
                db.createUser('user1', 'hash', 'First', 'Last', 30, 'IT')
            ).rejects.toThrow('Username already exists')
        })

        it('should throw other errors', async () => {
            db.default.query.mockRejectedValue(new Error('DB error'))
            await expect(
                db.createUser('user1', 'hash', 'First', 'Last', 30, 'IT')
            ).rejects.toThrow('DB error')
        })
    })

    describe('findUserByUsername', () => {
        it('should return user rows', async () => {
            const mockRows = [{ id: 1, username: 'user1' }]
            db.default.query.mockResolvedValue([mockRows])
            const rows = await db.findUserByUsername('user1')
            expect(rows).toEqual(mockRows)
            expect(db.default.query).toHaveBeenCalledWith(expect.any(String), ['user1'])
        })
    })

    describe('addDog', () => {
        it('should add dog and return dog object', async () => {
            db.default.query.mockResolvedValue([{ insertId: 77 }])
            const dog = await db.addDog(1, 'Fido', 'bulldog', '2020-01-01', 'M', 15)

            expect(dog).toEqual({
                id: 77,
                userId: 1,
                name: 'Fido',
                breed: 'bulldog',
                birthDate: '2020-01-01',
                gender: 'M',
                weight: 15,
            })
        })
    })

    describe('getDogsByUserId', () => {
        it('should return dogs with formatted birthDate', async () => {
            const dogs = [
                { id: 1, userId: 1, name: 'Fido', breed: 'bulldog', birthDate: new Date('2020-01-01'), gender: 'M', weight: 15 },
            ]
            db.default.query.mockResolvedValue([dogs])

            const result = await db.getDogsByUserId(1)
            expect(result[0]).toMatchObject({
                birthDate: '2020-01-01',
            })
        })
    })

    describe('editDog', () => {
        it('should update dog fields and return updated dog', async () => {
            db.default.query
                .mockResolvedValueOnce([{ affectedRows: 1 }])
                .mockResolvedValueOnce([[{ id: 1, userId: 1, name: 'Fido', breed: 'bulldog', birthDate: new Date('2020-01-01'), gender: 'M', weight: 15 }]]) // select updated dog

            const updatedDog = await db.editDog(1, { name: 'Rex', weight: 20 })
            expect(updatedDog.name).toBe('Fido' || 'Rex')
            expect(updatedDog.birthDate).toBe('2020-01-01')
        })

        it('should throw error if no fields provided', async () => {
            await expect(db.editDog(1, {})).rejects.toThrow('No fields to update')
        })

        it('should throw if dog not found', async () => {
            db.default.query.mockResolvedValueOnce([{ affectedRows: 0 }])
            await expect(db.editDog(99, { name: 'Rex' })).rejects.toThrow('Dog not found')
        })
    })

    describe('deleteDog', () => {
        it('should delete dog if found and owned by user', async () => {
            db.default.query
                .mockResolvedValueOnce([[{ id: 1, userId: 1 }]])
                .mockResolvedValueOnce([{ affectedRows: 1 }])

            const res = await db.deleteDog(1, 1)
            expect(res).toEqual({ success: true, message: 'Dog deleted successfully', affectedRows: 1 })
        })

        it('should return failure if dog not found or wrong user', async () => {
            db.default.query.mockResolvedValueOnce([[]])
            const res = await db.deleteDog(1, 99)
            expect(res).toEqual({ success: false, message: 'Dog not found or not owned by this user' })
        })

        it('should return failure if DB error occurs', async () => {
            db.default.query.mockRejectedValueOnce(new Error('DB error'))
            const res = await db.deleteDog(1, 1)
            expect(res).toEqual({ success: false, message: 'Server error during deletion' })
        })
    })
})
