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

            let sortDescriptor = NSSortDescriptor(key: "dateAndTime", ascending: false)
            request.sortDescriptors = [sortDescriptor]
            
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
                return []
            }
        }
    }

    func saveMoodCard(card: MoodCard) async throws {
        try await context.perform {            let moodRequest: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
            moodRequest.predicate = NSPredicate(format: "id == %@", card.mood.id as CVarArg)
            moodRequest.fetchLimit = 1

            guard let moodEntity = try self.context.fetch(moodRequest).first else {
                throw NSError(domain: "JournalListRepository", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "Mood not found for id \(card.mood.id)"
                ])
            }

            let cardRequest: NSFetchRequest<MoodCardEntity> = MoodCardEntity.fetchRequest()
            cardRequest.predicate = NSPredicate(format: "id == %@", card.id as CVarArg)
            cardRequest.fetchLimit = 1

            let cardEntity = try self.context.fetch(cardRequest).first ?? MoodCardEntity(context: self.context)

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

    func deleteMoodCard(id: UUID) async throws {
        try await context.perform {
            let request: NSFetchRequest<MoodCardEntity> = MoodCardEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            request.fetchLimit = 1

            if let cardEntity = try self.context.fetch(request).first {
                self.context.delete(cardEntity)

                if self.context.hasChanges {
                    try self.context.save()
                }
            }
        }
    }
}
