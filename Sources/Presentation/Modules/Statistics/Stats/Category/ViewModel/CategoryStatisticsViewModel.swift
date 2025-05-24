//
//  CategoryStatisticsViewModel.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 15.05.2025.
//

final class CategoryStatisticsViewModel {

    // MARK: - Properties

    private let categoryData: CategoryData

    var amountOfNotes: Int {
        categoryData.amountOfNotes
    }

    var redPercent: Int {
        categoryData.redPercent
    }

    var bluePercent: Int {
        categoryData.bluePercent
    }

    var greenPercent: Int {
        categoryData.greenPercent
    }

    var orangePercent: Int {
        categoryData.orangePercent
    }

    // MARK: - Init

    init(categoryData: CategoryData) {
        self.categoryData = categoryData
    }
}
