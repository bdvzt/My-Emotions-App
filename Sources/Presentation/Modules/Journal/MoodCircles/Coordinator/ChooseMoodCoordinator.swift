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
    
    private let preselectedCard: MoodCard?
    
    init(
        navigationController: UINavigationController,
        dependencies: AppDependencyContainer,
        preselectedCard: MoodCard? = nil
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.preselectedCard = preselectedCard
        
        self.chooseMoodViewModel = dependencies.makeChooseMoodViewModel(preselectedMood: preselectedCard?.mood)
    }
    
    func start() {
        let viewController = ChooseMoodViewController(chooseMoodViewModel: self.chooseMoodViewModel)
        viewController.hidesBottomBarWhenPushed = true
        chooseMoodViewModel.delegate = self
        navigationController.pushViewController(viewController, animated: true)
        
        if let card = preselectedCard {
            DispatchQueue.main.async {
                self.showAddNote(with: card)
            }
        }
    }
    
    private func showAddNote(with card: MoodCard) {
        let viewModel = AddNoteViewModel(
            selectedMood: card.mood,
            repository: dependencies.journalListRepository,
            noteAnswersRepository: dependencies.noteAnswersRepository,
            existingCard: card
        )
        
        let coordinator = AddNoteCoordinator(
            navigationController: navigationController,
            addNoteViewModel: viewModel,
            dependencies: dependencies
        )
        addNoteCoordinator = coordinator
        viewModel.delegate = coordinator
        coordinator.start()
    }
    
    func showAddNoteScreen(with selectedMood: Mood) {
        let updatedCard: MoodCard? = {
            guard let card = preselectedCard else { return nil }
            return MoodCard(
                id: card.id,
                date: card.date,
                mood: selectedMood,
                activities: card.activities,
                people: card.people,
                places: card.places
            )
        }()
        
        let viewModel = AddNoteViewModel(
            selectedMood: selectedMood,
            repository: dependencies.journalListRepository,
            noteAnswersRepository: dependencies.noteAnswersRepository,
            existingCard: updatedCard
        )
        
        let coordinator = AddNoteCoordinator(
            navigationController: navigationController,
            addNoteViewModel: viewModel,
            dependencies: dependencies
        )
        viewModel.delegate = coordinator
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
