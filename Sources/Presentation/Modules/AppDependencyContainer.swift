//
//  AppDependencyContainer.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 09.05.2025.
//

import UIKit
import CoreData

final class AppDependencyContainer {
    let persistantContainer: NSPersistentContainer
    let journalListRepository: JournalListRepository
    let moodRepository: MoodRepository

    init() {
        persistantContainer = NSPersistentContainer(name: "MyEmotions")
        persistantContainer.loadPersistentStores { _, error in
            if let error = error { fatalError("error: \(error)") }
        }

        self.moodRepository = MoodRepositoryImpl(context: persistantContainer.viewContext)
        self.journalListRepository = JournalListRepositoryImpl(context: persistantContainer.viewContext)
    }

    // MARK: - Login
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel()
    }

    // MARK: - TabBar
    func makeTabBarCoordinator(navigationController: UINavigationController) -> TabBarCoordinator {
        TabBarCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }

    // MARK: - JournalList
    func makeJournalListViewModel() -> JournalListViewModel {
        JournalListViewModel(repository: self.journalListRepository)
    }

    func makeJournalListCoordinator(navigationController: UINavigationController) -> JournalListCoordinator {
        let viewModel = makeJournalListViewModel()
        let coordinator = JournalListCoordinator(
            navigationController: navigationController,
            journalListViewModel: viewModel,
            dependencies: self
        )
        viewModel.navigationDelegate = coordinator
        return coordinator
    }

    // MARK: - ChooseMood
    func makeChooseMoodViewModel() -> ChooseMoodViewModel {
        ChooseMoodViewModel(
            journalListRepository: self.journalListRepository,
            moodRepository: moodRepository
        )
    }

    func makeChooseMoodCoordinator(navigationController: UINavigationController) -> ChooseMoodCoordinator {
        let viewModel = makeChooseMoodViewModel()
        let coordinator = ChooseMoodCoordinator(
            navigationController: navigationController,
            chooseMoodViewModel: viewModel,
            dependencies: self
        )
        viewModel.delegate = coordinator
        return coordinator
    }

    // MARK: - Add Note
    func makeAddNoteViewModel(selectedMood: Mood) -> AddNoteViewModel {
        AddNoteViewModel(
            selectedMood: selectedMood,
            repository: journalListRepository
        )
    }

    func makeAddNoteCoordinator(
        navigationController: UINavigationController,
        selectedMood: Mood
    ) -> AddNoteCoordinator {
        let viewModel = makeAddNoteViewModel(selectedMood: selectedMood)
        let coordinator = AddNoteCoordinator(
            navigationController: navigationController,
            addNoteViewModel: viewModel,
            dependencies: self
        )
        viewModel.delegate = coordinator
        return coordinator
    }
}
