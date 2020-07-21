//
//  ToDoViewController+UITabBar.swift
//  ToDo
//
//  Created by Shagara F Nasution on 10/07/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

extension ToDoViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let selectedDate = self.selectedDate {
            let createToDoVC = CreateToDoViewController()
            
            createToDoVC.delegate = self
            createToDoVC.selectedDate = selectedDate
            
            present(createToDoVC, animated: true, completion: nil)
        }
    }
}
