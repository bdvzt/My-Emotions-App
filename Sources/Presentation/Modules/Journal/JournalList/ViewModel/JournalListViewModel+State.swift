//
//  JournalListViewModel+State.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 11.05.2025.
//

extension JournalListViewModel {
    enum State {
        case loading
        case loaded([MoodCardViewModel])
        case empty
        case error(String)
    }
}
