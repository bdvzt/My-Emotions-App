//
//  MoodRepositoryImpl.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 09.05.2025.
//

import CoreData
import UIKit

final class MoodRepositoryImpl: MoodRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchAll() -> [Mood] {
        let entities = (try? context.fetch(MoodEntity.fetchRequest())) ?? []
        return entities.compactMap { Mood(entity: $0) }
    }

    func setMoodsIfNeeded() {
        let request: NSFetchRequest<MoodEntity> = MoodEntity.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        guard count == 0 else { return }

        let defaultMoods: [Mood] = [
            // красные
            Mood(id: UUID(),
                 title: "Ярость",
                 icon: "Anxiety",
                 moodInfo: "ощущение сильного раздражения и злости",
                 colorType: .red),
            Mood(id: UUID(),
                 title: "Напряжение",
                 icon: "Red2",
                 moodInfo: "ощущение внутреннего стресса и готовности взорваться",
                 colorType: .red),
            Mood(id: UUID(),
                 title: "Зависть",
                 icon: "Red3",
                 moodInfo: "ощущение недовольства своими результатами рядом с чужими успехами",
                 colorType: .red),
            Mood(id: UUID(),
                 title: "Беспокойство",
                 icon: "Red4",
                 moodInfo: "ощущение тревоги и волнения без ясной причины",
                 colorType: .red),

            // оранжевые
            Mood(id: UUID(),
                 title: "Возбуждение",
                 icon: "Happiness",
                 moodInfo: "прилив энергии и предвкушение чего-то интересного",
                 colorType: .orange),
            Mood(id: UUID(),
                 title: "Восторг",
                 icon: "Orange2",
                 moodInfo: "ощущение абсолютного восторга и удивления",
                 colorType: .orange),
            Mood(id: UUID(),
                 title: "Уверенность",
                 icon: "Orange3",
                 moodInfo: "ощущение своих сил и веры в успех",
                 colorType: .orange),
            Mood(id: UUID(),
                 title: "Счастье",
                 icon: "Orange4",
                 moodInfo: "спокойная радость и удовлетворение жизнью",
                 colorType: .orange),

            // синие
            Mood(id: UUID(),
                 title: "Выгорание",
                 icon: "BurnOut",
                 moodInfo: "эмоциональное и физическое истощение после длительной нагрузки",
                 colorType: .blue),
            Mood(id: UUID(),
                 title: "Усталость",
                 icon: "BurnOut",
                 moodInfo: "ощущение, что необходимо отдохнуть",
                 colorType: .blue),
            Mood(id: UUID(),
                 title: "Депрессия",
                 icon: "Blue3",
                 moodInfo: "ощущение безысходности и утраты интереса к жизни",
                 colorType: .blue),
            Mood(id: UUID(),
                 title: "Апатия",
                 icon: "Blue4",
                 moodInfo: "ощущение безразличия и отсутствия мотивации",
                 colorType: .blue),

            // зелёные
            Mood(id: UUID(),
                 title: "Спокойствие",
                 icon: "Calmness",
                 moodInfo: "ощущение внутреннего покоя и умиротворения",
                 colorType: .green),
            Mood(id: UUID(),
                 title: "Удовлетворённость",
                 icon: "Green2",
                 moodInfo: "ощущение полного удовлетворения результатами своих действий",
                 colorType: .green),
            Mood(id: UUID(),
                 title: "Благодарность",
                 icon: "Green3",
                 moodInfo: "ощущение признательности за то, что имеешь",
                 colorType: .green),
            Mood(id: UUID(),
                 title: "Защищённость",
                 icon: "Green4",
                 moodInfo: "ощущение безопасности и уверенности в будущем",
                 colorType: .green),
        ]

        for mood in defaultMoods {
            let moodEntity = MoodEntity(context: context)
            moodEntity.id = mood.id
            moodEntity.title = mood.title
            moodEntity.moodInfo = mood.moodInfo
            moodEntity.color = mood.colorType.rawValue
            moodEntity.icon = mood.icon
        }

        do {
            try context.save()
            print("все супер!!!!")
        } catch {
            print("изначальные настроения не сохранились", error)
        }
    }
}
