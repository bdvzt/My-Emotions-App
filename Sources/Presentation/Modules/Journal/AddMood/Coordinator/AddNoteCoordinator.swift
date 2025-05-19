//
//  AddNoteCoordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 10.05.2025.
//

import UIKit

final class AddNoteCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let addNoteViewModel: AddNoteViewModel
    private let dependencies: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        addNoteViewModel: AddNoteViewModel,
        dependencies: AppDependencyContainer
    ) {
        self.navigationController = navigationController
        self.addNoteViewModel = addNoteViewModel
        self.dependencies = dependencies
    }

    func start() {
        let activitiesViewModel = NoteAnswersViewModel(
            repository: dependencies.noteAnswersRepository,
            category: "activities"
        )
        let peopleViewModel = NoteAnswersViewModel(
            repository: dependencies.noteAnswersRepository,
            category: "people"
        )
        let placesViewModel = NoteAnswersViewModel(
            repository: dependencies.noteAnswersRepository,
            category: "places"
        )

        let viewController = AddNoteViewController(
            viewModel: self.addNoteViewModel,
            activitiesViewModel: activitiesViewModel,
            peopleViewModel: peopleViewModel,
            placesViewModel: placesViewModel
        )

        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension AddNoteCoordinator: AddNoteViewModelDelegate {
    func didSaveNote() {
        DispatchQueue.main.async {
            self.navigationController.popToRootViewController(animated: true)
        }
    }
}
