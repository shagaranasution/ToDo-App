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
            let formToDoVC = FormToDoViewController()
            
            formToDoVC.delegate = self
            formToDoVC.selectedDate = selectedDate
            
            present(formToDoVC, animated: true, completion: nil)
        }
    }
}
