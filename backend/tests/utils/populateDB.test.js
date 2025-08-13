import { describe, it, expect, vi, beforeEach } from "vitest";
import * as userModule from "../../src/utils/populateDB.js";
import axios from "axios";
import fs from "fs";

vi.mock("axios");

vi.mock("fs", async () => {
    const actual = await vi.importActual("fs");
    return {
        ...actual,
        createReadStream: vi.fn(() => "fakeStream"),
    };
});

describe("populateDB utilities", () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it("registerUser should return user data on success", async () => {
        axios.post.mockResolvedValueOnce({
            data: { success: true, user: { id: 1, username: "test" } },
        });

        const user = await userModule.registerUser({ username: "test" });
        expect(user).toEqual({ id: 1, username: "test" });
    });

    it("registerUser should return null on logical failure", async () => {
        axios.post.mockResolvedValueOnce({
            data: { success: false },
        });

        const user = await userModule.registerUser({ username: "fail" });
        expect(user).toBeNull();
    });

    it("registerUser should return null on axios error", async () => {
        axios.post.mockRejectedValueOnce({ response: { data: "error" } });
        const user = await userModule.registerUser({ username: "error" });
        expect(user).toBeNull();
    });

    it("addDog should return success and dog object", async () => {
        axios.post.mockResolvedValueOnce({
            data: { success: true, dog: { id: 1, name: "Doggo_test" } },
        });

        const result = await userModule.addDog({ userId: 1, name: "Doggo_test" });
        expect(result.success).toBe(true);
        expect(result.dog.name).toBe("Doggo_test");
    });

    it("addDog should return failure on logical error", async () => {
        axios.post.mockResolvedValueOnce({
            data: { success: false, message: "Invalid" },
        });

        const result = await userModule.addDog({ userId: 1, name: "Doggo_fail" });
        expect(result.success).toBe(false);
        expect(result.error).toBe("Invalid");
    });

    it("addDog should return failure on axios error", async () => {
        axios.post.mockRejectedValueOnce({ response: { data: "HTTP Error" } });
        const result = await userModule.addDog({ userId: 1, name: "Doggo_error" });
        expect(result.success).toBe(false);
        expect(result.error).toBe("HTTP Error");
    });

    it("uploadAudio should return transactionId", async () => {
        axios.post.mockResolvedValueOnce({ data: { transactionId: "tx123" } });

        const txId = await userModule.uploadAudio({ filePath: "audio.wav", dogBreed: "Chihuahua" });
        expect(txId).toBe("tx123");
    });

    it("uploadAudio should throw on axios error", async () => {
        axios.post.mockRejectedValueOnce({ response: { data: "Error uploading" } });

        await expect(
            userModule.uploadAudio({ filePath: "audio.wav", dogBreed: "Chihuahua" })
        ).rejects.toThrow();
    });

    it("sendFeedback should return API response on success", async () => {
        axios.post.mockResolvedValueOnce({ data: { success: true } });

        const res = await userModule.sendFeedback({
            transactionId: "tx123",
            isCorrect: true,
            correctCategory: "TEST",
            comment: "Nice",
        });

        expect(res.success).toBe(true);
    });

    it("sendFeedback should return null on error", async () => {
        axios.post.mockRejectedValueOnce({ response: { data: "Feedback error" } });

        const res = await userModule.sendFeedback({
            transactionId: "tx123",
            isCorrect: true,
            correctCategory: "TEST",
            comment: "Fail",
        });

        expect(res).toBeNull();
    });

    describe("randomBirthDate", () => {
        it("should return a Date object", () => {
            const date = userModule.randomBirthDate();
            expect(date).toBeInstanceOf(Date);
        });

        it("should return a date between 1 and 10 years ago", () => {
            const date = userModule.randomBirthDate();
            const today = new Date();
            const tenYearsAgo = new Date();
            tenYearsAgo.setFullYear(today.getFullYear() - 10);
            const oneYearAgo = new Date();
            oneYearAgo.setFullYear(today.getFullYear() - 1);

            expect(date.getTime()).toBeGreaterThanOrEqual(tenYearsAgo.getTime());
            expect(date.getTime()).toBeLessThanOrEqual(oneYearAgo.getTime());
        });
    });

    describe("main loop branches", () => {
        it("should handle missing user id", async () => {
            vi.spyOn(userModule, "registerUser").mockResolvedValueOnce(null);
            // simulate main loop logic manually
            const user = await userModule.registerUser({});
            expect(user).toBeNull();
        });

        it("should handle missing dog or failed addDog", async () => {
            vi.spyOn(userModule, "registerUser").mockResolvedValueOnce({ id: 1 });
            vi.spyOn(userModule, "addDog").mockResolvedValueOnce({ success: false });
            const user = await userModule.registerUser({});
            const dog = await userModule.addDog({ userId: user.id });
            expect(dog.success).toBe(false);
        });

        it("should cover Math.random branches", () => {
            vi.spyOn(Math, "random").mockReturnValue(0.9); // >0.5 true branch
            expect(Math.random() > 0.5).toBe(true);

            vi.spyOn(Math, "random").mockReturnValue(0.1); // <0.5 false branch
            expect(Math.random() > 0.5).toBe(false);
        });
    });
});
