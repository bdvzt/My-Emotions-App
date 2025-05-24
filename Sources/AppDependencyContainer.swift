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
    let noteStatRepository: NoteStatRepository
    let moodRepository: MoodRepository
    let settingsRepository: SettingsRepository
    let statisticsRepository: StatisticsRepository
    let noteAnswersRepository : NoteAnswersRepository

    init() {
        persistantContainer = NSPersistentContainer(name: "MyEmotions")
        persistantContainer.loadPersistentStores { _, error in
            if let error = error { fatalError("error: \(error)") }
        }

        self.moodRepository = MoodRepositoryImpl(context: persistantContainer.viewContext)
        self.journalListRepository = JournalListRepositoryImpl(context: persistantContainer.viewContext)
        self.noteStatRepository = NoteStatRepositoryImpl(context: persistantContainer.viewContext)
        self.settingsRepository = SettingsRepositoryImpl()
        self.noteAnswersRepository  = NoteAnswersRepositoryImpl()
        self.statisticsRepository = StatisticsRepositoryImpl(context: persistantContainer.viewContext)
    }

    // MARK: - Login
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(repository: settingsRepository)
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
        JournalListViewModel(
            repository: self.journalListRepository,
            statRepository: self.noteStatRepository
        )
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
    func makeChooseMoodViewModel(preselectedMood: Mood? = nil) -> ChooseMoodViewModel {
        ChooseMoodViewModel(
            journalListRepository: journalListRepository,
            moodRepository: moodRepository,
            preselectedMood: preselectedMood
        )
    }
    func makeChooseMoodCoordinator(
        navigationController: UINavigationController,
        preselectedCard: MoodCard? = nil) -> ChooseMoodCoordinator {
            let coordinator = ChooseMoodCoordinator(
                navigationController: navigationController,
                dependencies: self,
                preselectedCard: preselectedCard
            )
            coordinator.chooseMoodViewModel.delegate = coordinator
            return coordinator
        }

    // MARK: - Add Note
    func makeAddNoteViewModel(selectedMood: Mood) -> AddNoteViewModel {
        AddNoteViewModel(
            selectedMood: selectedMood,
            repository: journalListRepository,
            noteAnswersRepository: noteAnswersRepository
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

    // MARK: - Settings
    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(repository: settingsRepository)
    }

    func makeSettingsCoordinator(navigationController: UINavigationController) -> SettingsCoordinator {
        let viewModel = makeSettingsViewModel()
        let coordinator = SettingsCoordinator(
            navigationController: navigationController,
            settingsViewModel: viewModel,
            dependencies: self
        )
        viewModel.delegate = coordinator
        return coordinator
    }

    // MARK: - Statistics
    func makeStatisticsViewModel() -> StatisticsViewModel {
        StatisticsViewModel(repository: statisticsRepository)
    }

    func makeStatisticsCoordinator(navigationController: UINavigationController) -> StatisticsCoordinator {
        let viewModel = makeStatisticsViewModel()
        let coordinator =  StatisticsCoordinator(
            navigationController: navigationController,
            statisticsViewModel: viewModel,
            dependencies: self)
        viewModel.delegate = coordinator
        return coordinator
    }
}
