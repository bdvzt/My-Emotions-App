//
//  JournalListRepositoryImpl.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 05.05.2025.
//

import UIKit
import CoreData

final class JournalListRepositoryImpl: JournalListRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getMoodCards() async throws -> [MoodCard] {
        await context.perform {
            let request: NSFetchRequest<MoodCardEntity> = MoodCardEntity.fetchRequest()

            do {
                let moodCards = try self.context.fetch(request)
                return moodCards.compactMap { moodCardEntity in
                    guard let moodEntity = moodCardEntity.mood,
                          let mood = moodEntity.toDomain(),
                          let moodCard = moodCardEntity.toDomain(with: mood) else {
                        return nil
                    }
                    return moodCard
                }
            } catch {
                print("[JournalListRepositoryImpl] — ошибка при получении карточек настроения: \(error)")
                return []
            }
        }
    }

    func saveMoodCard(card: MoodCard) async throws {
        try await context.perform {
            let moodRequest: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
            moodRequest.predicate = NSPredicate(format: "id==%@", card.mood.id as CVarArg)
            moodRequest.fetchLimit = 1

            let fetched = try self.context.fetch(moodRequest)
            guard let moodEntity = fetched.first else {
                let error = NSError(
                    domain: "JournalListRepository",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Mood not found for id \(card.mood.id)"]
                )
                print("[JournalListRepositoryImpl] ❌ Ошибка: \(error.localizedDescription)")
                throw error
            }

            let cardEntity = MoodCardEntity(context: self.context)
            cardEntity.id = card.id
            cardEntity.dateAndTime = card.date
            cardEntity.activities = card.activities
            cardEntity.people = card.people
            cardEntity.places = card.places
            cardEntity.mood = moodEntity

            if self.context.hasChanges {
                try self.context.save()
            }
        }
    }
}
