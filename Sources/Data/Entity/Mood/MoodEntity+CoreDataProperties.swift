//
//  MoodEntity+CoreDataProperties.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 10.05.2025.
//
//

import Foundation
import CoreData


extension MoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodEntity> {
        return NSFetchRequest<MoodEntity>(entityName: "MoodEntity")
    }

    @NSManaged public var color: String?
    @NSManaged public var icon: String?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var moodInfo: String?
    @NSManaged public var card: NSSet?

}

// MARK: Generated accessors for card
extension MoodEntity {

    @objc(addCardObject:)
    @NSManaged public func addToCard(_ value: MoodCardEntity)

    @objc(removeCardObject:)
    @NSManaged public func removeFromCard(_ value: MoodCardEntity)

    @objc(addCard:)
    @NSManaged public func addToCard(_ values: NSSet)

    @objc(removeCard:)
    @NSManaged public func removeFromCard(_ values: NSSet)

}
