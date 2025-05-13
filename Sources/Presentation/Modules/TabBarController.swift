//
//  TabBarController.swift
//  MyEmotions
//
//  Created by Zayata Budaeva on 01.05.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }
    
    private func configureAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .tabBar
            
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "VelaSans-Regular", size: 10)!
            ]
            
            let normalAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.tabBarUnselected,
                .font: UIFont(name: "VelaSans-Regular", size: 10)!
            ]
            
            let itemAppearance = appearance.stackedLayoutAppearance
            itemAppearance.selected.iconColor = .white
            itemAppearance.normal.iconColor = .tabBarUnselected
            itemAppearance.selected.titleTextAttributes = selectedAttributes
            itemAppearance.normal.titleTextAttributes = normalAttributes
            
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = .tabBar
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .tabBarUnselected
        }
    }
}
