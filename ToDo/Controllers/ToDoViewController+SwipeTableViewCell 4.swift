//
//  ToDoViewController+SwipeTableViewCell.swift
//  ToDo
//
//  Created by Shagara F Nasution on 26/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import SwipeCellKit

//MARK: - SwipeTableViewCell Delegate Methods

extension ToDoViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if let item = toDoItems?[indexPath.row] {
            if orientation == .right {
                let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
                    do {
                        try self.realm.write {
                            self.realm.delete(item)
                        }
                    } catch {
                        print("Error when deleting task item, \(error)")
                    }
                    
                    self.toDoListView.reloadData()
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

//MARK: - Extenstion String

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        
        return attributeString
    }
}

//MARK: - Extenstion UILabel

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

