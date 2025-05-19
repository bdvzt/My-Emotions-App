//
//  JournalListCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

import UIKit

final class JournalListCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let journalListViewModel: JournalListViewModel
    private let dependecies: AppDependencyContainer
    private var chooseMoodCoordinator: ChooseMoodCoordinator?

    init(
        navigationController: UINavigationController,
        journalListViewModel: JournalListViewModel,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.journalListViewModel = journalListViewModel
        self.dependecies = dependencies
    }

    func start() {
        let viewController = JournalListViewController(journalListViewModel: journalListViewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showChooseMoodScreen() {
        let chooseMoodCoordinator = dependecies.makeChooseMoodCoordinator(navigationController: navigationController)
        self.chooseMoodCoordinator = chooseMoodCoordinator
        chooseMoodCoordinator.start()
    }
}

extension JournalListCoordinator: JournalListViewModelDelegate {
    func didRequestAddMood() {
        showChooseMoodScreen()
    }
}
