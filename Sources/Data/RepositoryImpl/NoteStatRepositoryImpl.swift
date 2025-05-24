//
//  NoteStatRepositoryImpl.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 20.05.2025.
//

import Foundation
import CoreData

final class NoteStatRepositoryImpl: NoteStatRepository {
    private let context: NSManagedObjectContext
    private let goalKey = "daily_goal"

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func loadStatistics() -> NoteStatistics {
        do {
            let request: NSFetchRequest<MoodCardEntity> = MoodCardEntity.fetchRequest()
            let entities = try context.fetch(request)

            let domainCards: [MoodCard] = entities.compactMap { entity in
                guard let mood = entity.mood?.toDomain(),
                      let card = entity.toDomain(with: mood) else {
                    return nil
                }
                return card
            }

            let rawGoal = UserDefaults.standard.integer(forKey: goalKey)
            let dailyGoal = rawGoal == 0 ? 1 : rawGoal

            return NoteStatisticsCalculator.calculate(from: domainCards, dailyGoal: dailyGoal)
        } catch {
            return NoteStatistics(
                totalCount: 0,
                dailyGoal: 1,
                streak: 0,
                circleStatistics: CircleStatistics(goalPercent: 0, bluePercent: 0, greenPercent: 0, redPercent: 0, orangePercent: 0)
            )
        }
    }

    func updateGoal(_ newGoal: Int) {
        UserDefaults.standard.set(newGoal, forKey: goalKey)
    }
}
