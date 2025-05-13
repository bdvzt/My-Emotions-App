//
//  MoodCardEntity+CoreDataProperties.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 11.05.2025.
//
//

import Foundation
import CoreData


extension MoodCardEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoodCardEntity> {
        return NSFetchRequest<MoodCardEntity>(entityName: "MoodCardEntity")
    }

    @NSManaged public var activities: [String]?
    @NSManaged public var dateAndTime: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var people: [String]?
    @NSManaged public var places: [String]?
    @NSManaged public var mood: MoodEntity?

}
