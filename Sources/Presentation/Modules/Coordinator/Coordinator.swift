//
//  Coordinator.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }

    func start()
}
