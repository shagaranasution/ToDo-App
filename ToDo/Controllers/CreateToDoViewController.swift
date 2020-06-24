//
//  CreateToDoViewController.swift
//  ToDo
//
//  Created by Shagara F Nasution on 18/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

class CreateToDoViewController: UIViewController, UITextFieldDelegate, TimePickerViewControllerDelegate {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var addStartTimeTextField: UITextField!
    @IBOutlet weak var addEndTimeTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var startDateTime: Date?
    var finishDateTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
        taskNameTextField.delegate = self
        addStartTimeTextField.delegate = self
        addEndTimeTextField.delegate = self
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        taskNameTextField.becomeFirstResponder()
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
            addEndTimeTextField.isEnabled  = false
            
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
        
        self.addStartTimeTextField.isEnabled = true
        self.addEndTimeTextField.isEnabled = true
        
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
    }
    
    func timePickerViewControllerDidCancel(_ timePickerViewController: TimePickerViewController) {
        dismiss(animated: true, completion: nil)
    
        self.addStartTimeTextField.isEnabled = true
        self.addEndTimeTextField.isEnabled = true
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let taskName = taskNameTextField.text, let startTime = startDateTime, let finishTime = finishDateTime {
            print(taskName, startTime, finishTime)
        }
    }
    
    private func configureView() {
        // customizing task name textfield
        taskNameTextField.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        taskNameTextField.layer.borderWidth = 1.0
        taskNameTextField.layer.cornerRadius = 10.0
        taskNameTextField.layer.masksToBounds = true
        taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Name of the task", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        // customizing add start time textfield
        addStartTimeTextField.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        addStartTimeTextField.layer.borderWidth = 1.0
        addStartTimeTextField.layer.cornerRadius = 10.0
        addStartTimeTextField.layer.masksToBounds = true
        addStartTimeTextField.attributedPlaceholder = NSAttributedString(string: "Add start time", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        // customizing add end time text field
        addEndTimeTextField.layer.borderColor = #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 1)
        addEndTimeTextField.layer.borderWidth = 1.0
        addEndTimeTextField.layer.cornerRadius = 10.0
        addEndTimeTextField.layer.masksToBounds = true
        addEndTimeTextField.attributedPlaceholder = NSAttributedString(string: "Add finish time", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
        
        // customizing add button
        addButton.layer.cornerRadius = 10.0
    }

}
