//
//  MostFrequentViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 15.05.2025.
//

final class MostFrequentViewModel {

    // MARK: - Properties
    let cards: [FrequencyData]
    let maxAmount: Int

    // MARK: - Init
    init(data: [FrequencyData]) {
        self.cards = data
        self.maxAmount = data.map { $0.amount }.max() ?? 1
    }
}
