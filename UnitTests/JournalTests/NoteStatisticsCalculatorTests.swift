//
//  NoteStatisticsCalculatorTests.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import XCTest
@testable import MyEmotions

final class NoteStatisticsCalculatorTests: XCTestCase {

    // MARK: - Helpers
    private func makeMoodCard(date: Date, color: MoodColorType) -> MoodCard {
        let mood = Mood(
            id: UUID(),
            title: "Test",
            icon: "testIcon",
            moodInfo: "testInfo",
            colorType: color
        )

        return MoodCard(
            id: UUID(),
            date: date,
            mood: mood,
            activities: [],
            people: [],
            places: []
        )
    }

    // MARK: - Tests

    /// при наличии карточек на сегодня с достижением цели
    func testCalculate_goalReachedToday_shouldReturnCorrectStats() {
        let today = Date().startOfDay
        let cards = [
            makeMoodCard(date: today, color: .blue),
            makeMoodCard(date: today, color: .green),
            makeMoodCard(date: today, color: .red)
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 3)

        XCTAssertEqual(stats.totalCount, 3)
        XCTAssertEqual(stats.streak, 1)
        XCTAssertEqual(stats.circleStatistics.goalPercent, 1.0)
        XCTAssertEqual(stats.circleStatistics.bluePercent, 1.0 / 3.0, accuracy: 0.01)
        XCTAssertEqual(stats.circleStatistics.greenPercent, 1.0 / 3.0, accuracy: 0.01)
        XCTAssertEqual(stats.circleStatistics.redPercent, 1.0 / 3.0, accuracy: 0.01)
        XCTAssertEqual(stats.circleStatistics.orangePercent, 0.0)
    }

    /// два дня подряд с выполненной целью (ожидается страйк 2)
    func testCalculate_streakTwoDays_shouldReturnTwo() {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let cards = [
            makeMoodCard(date: today, color: .red),
            makeMoodCard(date: today, color: .blue),
            makeMoodCard(date: yesterday, color: .green),
            makeMoodCard(date: yesterday, color: .orange)
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 2)

        XCTAssertEqual(stats.streak, 2)
    }

    /// цель превышена, но процент выполнения не превышает 100
    func testCalculate_goalPercentShouldNotExceedOne() {
        let today = Date().startOfDay
        let cards = (0..<10).map { _ in makeMoodCard(date: today, color: .blue) }

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 5)

        XCTAssertEqual(stats.circleStatistics.goalPercent, 1.0)
    }

    /// отсутствие карточек
    func testCalculate_emptyCards_shouldReturnZeroStats() {
        let stats = NoteStatisticsCalculator.calculate(from: [], dailyGoal: 3)

        XCTAssertEqual(stats.totalCount, 0)
        XCTAssertEqual(stats.streak, 0)
        XCTAssertEqual(stats.circleStatistics.goalPercent, 0)
        XCTAssertEqual(stats.circleStatistics.bluePercent, 0)
        XCTAssertEqual(stats.circleStatistics.greenPercent, 0)
        XCTAssertEqual(stats.circleStatistics.redPercent, 0)
        XCTAssertEqual(stats.circleStatistics.orangePercent, 0)
    }

    /// прерывание страйка
    func testCalculate_streakBreak_shouldReturnZero() {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!

        let cards = [
            makeMoodCard(date: today, color: .green),
            makeMoodCard(date: yesterday, color: .green),
            makeMoodCard(date: twoDaysAgo, color: .green),
            makeMoodCard(date: twoDaysAgo, color: .blue)
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 2)

        XCTAssertEqual(stats.streak, 0)
    }

    /// разные цвета и проверка, что каждый из них корректно считается
    func testCalculate_colorDistribution_shouldBeCorrect() {
        let today = Date().startOfDay
        let cards = [
            makeMoodCard(date: today, color: .blue),
            makeMoodCard(date: today, color: .blue),
            makeMoodCard(date: today, color: .green),
            makeMoodCard(date: today, color: .red),
            makeMoodCard(date: today, color: .orange)
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 5)

        XCTAssertEqual(stats.circleStatistics.bluePercent, 2.0 / 5.0, accuracy: 0.01)
        XCTAssertEqual(stats.circleStatistics.greenPercent, 1.0 / 5.0, accuracy: 0.01)
        XCTAssertEqual(stats.circleStatistics.redPercent, 1.0 / 5.0, accuracy: 0.01)
        XCTAssertEqual(stats.circleStatistics.orangePercent, 1.0 / 5.0, accuracy: 0.01)
    }

    /// если карточки только в прошлом, но today пустой — streak должен быть 0
    func testCalculate_noCardsToday_shouldReturnStreakZero() {
        let calendar = Calendar.current
        let fiveDaysAgo = calendar.date(byAdding: .day, value: -5, to: Date())!.startOfDay
        let cards = [
            makeMoodCard(date: fiveDaysAgo, color: .blue),
            makeMoodCard(date: fiveDaysAgo, color: .red)
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 2)

        XCTAssertEqual(stats.streak, 0)
    }

    /// если одна карточка каждый день и цель равна 1, то страйк должен быть равен количеству дней
    func testCalculate_singleCardEachDay_goalOne_streakShouldMatchDayCount() {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!

        let cards = [
            makeMoodCard(date: today, color: .green),
            makeMoodCard(date: yesterday, color: .green),
            makeMoodCard(date: twoDaysAgo, color: .green)
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 1)

        XCTAssertEqual(stats.streak, 3)
    }

    /// страйк считается строго от самого последнего дня
    func testCalculate_futureDate_breaksStreak() {
        let calendar = Calendar.current
        let futureDate = calendar.date(byAdding: .day, value: 1, to: Date())!.startOfDay
        let today = Date().startOfDay
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!

        let cards = [
            makeMoodCard(date: futureDate, color: .blue),
            makeMoodCard(date: yesterday, color: .green),
            makeMoodCard(date: yesterday, color: .red),
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 2)

        XCTAssertEqual(stats.streak, 0)
    }

    /// подсчёт общего количества карточек
    func testCalculate_totalCount_shouldMatchCardsArrayCount() {
        let calendar = Calendar.current
        let today = Date().startOfDay
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!

        let cards = [
            makeMoodCard(date: today, color: .blue),
            makeMoodCard(date: today, color: .green),
            makeMoodCard(date: yesterday, color: .orange),
            makeMoodCard(date: twoDaysAgo, color: .red),
            makeMoodCard(date: twoDaysAgo, color: .green),
            makeMoodCard(date: twoDaysAgo, color: .blue)
        ]

        let stats = NoteStatisticsCalculator.calculate(from: cards, dailyGoal: 2)

        XCTAssertEqual(stats.totalCount, 6)
    }
}
