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
                 icon: "Anxiety",
                 moodInfo: "ощущение внутреннего стресса и готовности взорваться",
                 colorType: .red),
            Mood(id: UUID(),
                 title: "Зависть",
                 icon: "Anxiety",
                 moodInfo: "ощущение недовольства своими результатами рядом с чужими успехами",
                 colorType: .red),
            Mood(id: UUID(),
                 title: "Беспокойство",
                 icon: "Anxiety",
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
                 icon: "Happiness",
                 moodInfo: "ощущение абсолютного восторга и удивления",
                 colorType: .orange),
            Mood(id: UUID(),
                 title: "Уверенность",
                 icon: "Happiness",
                 moodInfo: "ощущение своих сил и веры в успех",
                 colorType: .orange),
            Mood(id: UUID(),
                 title: "Счастье",
                 icon: "Happiness",
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
                 icon: "BurnOut",
                 moodInfo: "ощущение безысходности и утраты интереса к жизни",
                 colorType: .blue),
            Mood(id: UUID(),
                 title: "Апатия",
                 icon: "BurnOut",
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
                 icon: "Calmness",
                 moodInfo: "ощущение полного удовлетворения результатами своих действий",
                 colorType: .green),
            Mood(id: UUID(),
                 title: "Благодарность",
                 icon: "Calmness",
                 moodInfo: "ощущение признательности за то, что имеешь",
                 colorType: .green),
            Mood(id: UUID(),
                 title: "Защищённость",
                 icon: "Calmness",
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
