//
//  CreateToDoViewController+UITextField.swift
//  ToDo
//
//  Created by Shagara F Nasution on 26/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

// Text Field Delegate Methods

extension CreateToDoViewController: UITextFieldDelegate {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
