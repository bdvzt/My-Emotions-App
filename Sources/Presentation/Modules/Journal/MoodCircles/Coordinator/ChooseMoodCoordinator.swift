//
//  ChooseMoodCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 09.05.2025.
//

import UIKit

final class ChooseMoodCoordinator: Coordinator {
    var navigationController: UINavigationController
    let chooseMoodViewModel: ChooseMoodViewModel
    private let dependencies: AppDependencyContainer
    private var addNoteCoordinator: AddNoteCoordinator?

    init(
        navigationController: UINavigationController,
        chooseMoodViewModel: ChooseMoodViewModel,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.chooseMoodViewModel = chooseMoodViewModel
        self.dependencies = dependencies
    }

    func start() {
        let viewController = ChooseMoodViewController(chooseMoodViewModel: self.chooseMoodViewModel)
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    func showAddNoteScreen(with selectedMood: Mood) {
        let coordinator = dependencies.makeAddNoteCoordinator(
            navigationController: navigationController,
            selectedMood: selectedMood
        )
        self.addNoteCoordinator = coordinator
        coordinator.start()
    }
}

extension ChooseMoodCoordinator: ChooseMoodViewModelDelegate {
    func didChooseMood() {
        guard let selectedMood = chooseMoodViewModel.selectedMood else { return }
        showAddNoteScreen(with: selectedMood)
    }
}
