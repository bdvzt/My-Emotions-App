//
//  MockMoods.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 24.05.2025.
//

import Foundation
@testable import MyEmotions

enum MockMoods {
    static let moods: [Mood] = [
        Mood(id: UUID(), title: "Ярость", icon: "Anxiety", moodInfo: "ощущение сильного раздражения и злости", colorType: .red),
        Mood(id: UUID(), title: "Напряжение", icon: "Red2", moodInfo: "ощущение внутреннего стресса и готовности взорваться", colorType: .red),
        Mood(id: UUID(), title: "Зависть", icon: "Red3", moodInfo: "ощущение недовольства своими результатами рядом с чужими успехами", colorType: .red),
        Mood(id: UUID(), title: "Беспокойство", icon: "Red4", moodInfo: "ощущение тревоги и волнения без ясной причины", colorType: .red),

        Mood(id: UUID(), title: "Возбуждение", icon: "Happiness", moodInfo: "прилив энергии и предвкушение чего-то интересного", colorType: .orange),
        Mood(id: UUID(), title: "Восторг", icon: "Orange2", moodInfo: "ощущение абсолютного восторга и удивления", colorType: .orange),
        Mood(id: UUID(), title: "Уверенность", icon: "Orange3", moodInfo: "ощущение своих сил и веры в успех", colorType: .orange),
        Mood(id: UUID(), title: "Счастье", icon: "Orange4", moodInfo: "спокойная радость и удовлетворение жизнью", colorType: .orange),

        Mood(id: UUID(), title: "Выгорание", icon: "BurnOut", moodInfo: "эмоциональное и физическое истощение после длительной нагрузки", colorType: .blue),
        Mood(id: UUID(), title: "Усталость", icon: "BurnOut", moodInfo: "ощущение, что необходимо отдохнуть", colorType: .blue),
        Mood(id: UUID(), title: "Депрессия", icon: "Blue3", moodInfo: "ощущение безысходности и утраты интереса к жизни", colorType: .blue),
        Mood(id: UUID(), title: "Апатия", icon: "Blue4", moodInfo: "ощущение безразличия и отсутствия мотивации", colorType: .blue),

        Mood(id: UUID(), title: "Спокойствие", icon: "Calmness", moodInfo: "ощущение внутреннего покоя и умиротворения", colorType: .green),
        Mood(id: UUID(), title: "Удовлетворённость", icon: "Green2", moodInfo: "ощущение полного удовлетворения результатами своих действий", colorType: .green),
        Mood(id: UUID(), title: "Благодарность", icon: "Green3", moodInfo: "ощущение признательности за то, что имеешь", colorType: .green),
        Mood(id: UUID(), title: "Защищённость", icon: "Green4", moodInfo: "ощущение безопасности и уверенности в будущем", colorType: .green)
    ]
}
