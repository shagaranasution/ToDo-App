//
//  CreateToDoViewController.swift
//  ToDo
//
//  Created by Shagara F Nasution on 18/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import RealmSwift

protocol CreateToDoViewControllerDelegate: class {
    func didCreateToDo(_ createToDoViewController: CreateToDoViewController)
}

class CreateToDoViewController: UIViewController, UITextFieldDelegate, TimePickerViewControllerDelegate {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var addStartTimeTextField: UITextField!
    @IBOutlet weak var addEndTimeTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let realm = try! Realm()
    
    var startDateTime: Date?
    var finishDateTime: Date?
    
    weak var delegate: CreateToDoViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        taskNameTextField.delegate = self
        addStartTimeTextField.delegate = self
        addEndTimeTextField.delegate = self
        
//        addStartTimeTextField.inputView = UIView()
//        addStartTimeTextField.inputAccessoryView = UIView()
//        
//        addEndTimeTextField.inputView = UIView()
//        addEndTimeTextField.inputAccessoryView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.taskNameTextField.becomeFirstResponder()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case addStartTimeTextField:
            self.taskNameTextField.resignFirstResponder()
        case addEndTimeTextField:
            self.taskNameTextField.resignFirstResponder()
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case addStartTimeTextField:
            addStartTimeTextField.isEnabled  = false
            
            let timePickerVC = TimePickerViewController()
            timePickerVC.modalPresentationStyle = .custom
            timePickerVC.modalTransitionStyle = .crossDissolve
            
            timePickerVC.delegate = self
            timePickerVC.timeContextType = .startTime
            
            present(timePickerVC, animated: true, completion: nil)
        case addEndTimeTextField:
            addEndTimeTextField.isEnabled = false
            
            let timePickerVC = TimePickerViewController()
            timePickerVC.modalPresentationStyle = .custom
            timePickerVC.modalTransitionStyle = .crossDissolve
            
            timePickerVC.delegate = self
            timePickerVC.timeContextType = .finishTime
            
            present(timePickerVC, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func timePickerViewControllerDidSet(_ timePickerViewConroller: TimePickerViewController, timeContextType: TimeContextType, timeSet: Date) {
        dismiss(animated: true, completion: nil)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let stringTime = dateFormatter.string(from: timeSet)
        
        if timeContextType == .startTime {
            startDateTime = timeSet
            addStartTimeTextField.text = stringTime
        } else {
            finishDateTime = timeSet
            addEndTimeTextField.text = stringTime
        }
        
        self.addStartTimeTextField.isEnabled = true
        self.addEndTimeTextField.isEnabled = true
    }
    
    func timePickerViewControllerDidCancel(_ timePickerViewController: TimePickerViewController) {
        dismiss(animated: true, completion: nil)
        
        self.addStartTimeTextField.isEnabled = true
        self.addEndTimeTextField.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let taskName = taskNameTextField.text, let startTime = startDateTime, let finishTime = finishDateTime {
            print(taskName, startTime, finishTime)
            let newItem = Item()
            newItem.title = taskName
            newItem.startDateTime = startTime
            newItem.finishDateTime = finishTime
            
            save(item: newItem)
            
            self.delegate?.didCreateToDo(self)
        }
    }
    
    func save(item: Item) {
        do {
            try realm.write{
                realm.add(item)
            }
        } catch {
            print("Error when saving item, \(error)")
        }
    }
    
    private func configureView() {
        // customizing task name textfield
        taskNameTextField.layer.borderColor = UIColor(named: "cardColor")?.cgColor
        taskNameTextField.layer.borderWidth = 1.0
        taskNameTextField.layer.cornerRadius = 10.0
        taskNameTextField.layer.masksToBounds = true
        taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Name of the task", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        // customizing add start time textfield
        addStartTimeTextField.layer.borderColor = UIColor(named: "cardColor")?.cgColor
        addStartTimeTextField.layer.borderWidth = 1.0
        addStartTimeTextField.layer.cornerRadius = 10.0
        addStartTimeTextField.layer.masksToBounds = true
        addStartTimeTextField.attributedPlaceholder = NSAttributedString(string: "Add start time", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        // customizing add end time text field
        addEndTimeTextField.layer.borderColor = UIColor(named: "cardColor")?.cgColor
        addEndTimeTextField.layer.borderWidth = 1.0
        addEndTimeTextField.layer.cornerRadius = 10.0
        addEndTimeTextField.layer.masksToBounds = true
        addEndTimeTextField.attributedPlaceholder = NSAttributedString(string: "Add finish time", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        // customizing add button
        addButton.layer.cornerRadius = 10.0
    }
    
}
