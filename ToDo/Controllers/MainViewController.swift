//
//  MainViewController.swift
//  ToDo
//
//  Created by Shagara F Nasution on 17/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var toDoListView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var addToDo: UITabBarItem!
    
    let realm = try! Realm()
    
    var toDoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "containerColor")
        toDoListView.backgroundColor = UIColor(named: "containerColor")
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
        toDoListView.register(UINib(nibName: "EmptyToDoCell", bundle: nil), forCellReuseIdentifier: "reuseEmptyToDoCell")
        
        loadItems()
    }
    
    func loadItems() {
        toDoItems = realm.objects(Item.self)
        toDoListView.reloadData()
    }
}



//MARK: - TableView DataSource Methods

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return toDoItems?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if let item = toDoItems?[index] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
            cell.delegate = self

            cell.toDoTitle.text = item.title

            let dateFormatter = DateFormatter()

            let startDateTime = item.startDateTime
            let finishDateTime = item.finishDateTime

            dateFormatter.dateFormat = "E, d MMM yyyy"
            let stringMonth = dateFormatter.string(from: startDateTime)

            dateFormatter.timeStyle = DateFormatter.Style.short
            let stringStartTime = dateFormatter.string(from: startDateTime)
            let stringFinishTime = dateFormatter.string(from: finishDateTime)

            let stringTaskTime = "\(stringMonth), \(stringStartTime) - \(stringFinishTime)"
            cell.activityDate.text = stringTaskTime

            if !item.done {
                cell.toDoTitle.textColor = .label
                cell.activityDate.textColor = .label
            } else {
                cell.toDoTitle.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.activityDate.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }

            cell.toDoTitle.strikeThrough(item.done)
            cell.activityDate.strikeThrough(item.done)

            return cell
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseEmptyToDoCell", for: indexPath) as! EmptyToDoCell

            return cell
        }
    }
    
}

//MARK: - TabBar Delegate Methods

extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let createToDoVC = CreateToDoViewController()
        
        createToDoVC.delegate = self
        
        present(createToDoVC, animated: true, completion: nil)
    }
}

//MARK: - CreateToDoVC Delegate Methods

extension MainViewController: CreateToDoViewControllerDelegate {
    func didCreateToDo(_ createToDoViewController: CreateToDoViewController) {
        createToDoViewController.dismiss(animated: true, completion: nil)
        
        toDoListView.reloadData()
    }
}

//MARK: - SwipeTableViewCell Delegate Methods

extension MainViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if let item = toDoItems?[indexPath.row] {
            if orientation == .right {
                let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                    print("deleted")
                }
    
                // customize the action appearance
                deleteAction.image = UIImage(systemName: "trash.fill")
    
                return [deleteAction]
            }
            
            if orientation == .left {
                let makeDoneAction = SwipeAction(style: .destructive, title: nil) { (action, indexPath) in
                    print("make done", action)
                    do {
                        try self.realm.write{
                            item.done = true
                        }
                    } catch {
                        print("Error updating task status, \(error)")
                    }
                    
                    self.toDoListView.reloadData()
                }
                
                let makeUndoneAction = SwipeAction(style: .destructive, title: "Undo") { (action, indexPath) in
                    print("make undone", action)
                    do {
                        try self.realm.write{
                            item.done = false
                        }
                        
                    } catch {
                        print("Error updating task status, \(error)")
                    }
                    
                    self.toDoListView.reloadData()
                }
                
                makeDoneAction.image = UIImage(systemName: "checkmark")
                makeDoneAction.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.6196078431, blue: 0.4352941176, alpha: 1)
                makeUndoneAction.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.3843137255, blue: 0.3725490196, alpha: 1)
                
                if !item.done {
                    return [makeDoneAction]
                } else {
                    return [makeUndoneAction]
                }
            }
        }
        
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()

        options.expansionStyle = .none
        options.transitionStyle = .border

        return options
    }
    
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        
        return attributeString
    }
}

extension UILabel {
    func strikeThrough(_ isStrikeThrough:Bool) {
        if isStrikeThrough {
            if let lblText = self.text {
                let attributeString =  NSMutableAttributedString(string: lblText)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
                self.attributedText = attributeString
            }
        } else {
            if let attributedStringText = self.attributedText {
                let txt = attributedStringText.string
                
                self.attributedText = nil
                self.text = txt
                return
            }
        }
    }
}
