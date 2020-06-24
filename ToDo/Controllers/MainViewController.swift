//
//  MainViewController.swift
//  ToDo
//
//  Created by Shagara F Nasution on 17/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var toDoListView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var addToDo: UITabBarItem!
    
    var toDoItems = [ToDoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        toDoListView.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        toDoListView.separatorStyle = .none
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        navigationItem.title = "ToDo"
        
        let configAddToDoIcon = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .default)
       
        let addToDoIcon =  UIImage(systemName: "plus.circle.fill", withConfiguration: configAddToDoIcon)
        
        addToDo.image = addToDoIcon?.withTintColor(#colorLiteral(red: 0.9254901961, green: 0.3843137255, blue: 0.3725490196, alpha: 1), renderingMode: .alwaysOriginal)
    
        toDoListView.dataSource = self
        tabBar.delegate = self
        
        toDoListView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        
        var toDoItems1 = ToDoModel()
        toDoItems1.title = "Red News"
        toDoItems1.activityDate = "Dec 25, 08:00 - 09:00"
        
        var toDoItems2 = ToDoModel()
        toDoItems2.title = "Meeting"
        toDoItems2.activityDate = "Dec 25, 13:00 - 16:00"
        
        var toDoItems3 = ToDoModel()
        toDoItems3.title = "Work Out"
        toDoItems3.activityDate = "Dec 25, 19:00 - 21:00"
        
        toDoItems.append(toDoItems1)
        toDoItems.append(toDoItems2)
        toDoItems.append(toDoItems3)
    }

}



//MARK: - TableView DataSource Methods

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        cell.toDoTitle.text = toDoItems[indexPath.row].title
        cell.activityDate.text = toDoItems[indexPath.row].activityDate
        
        return cell
    }
    
    
}

//MARK: - TabBar Delegate Methods

extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let createToDoView = CreateToDoViewController()
        
        present(createToDoView, animated: true, completion: nil)
        
        print("pressed")
    }
}
