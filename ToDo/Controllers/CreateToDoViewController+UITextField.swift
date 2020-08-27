//
//  CreateToDoViewController+UITextField.swift
//  ToDo
//
//  Created by Shagara F Nasution on 26/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

//MARK: - Text Field Delegate Methods

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
            presentTimePickerView(for: .startTime)
        case addEndTimeTextField:
            addEndTimeTextField.isEnabled = false
            presentTimePickerView(for: .finishTime)
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
    
    private func presentTimePickerView(for timeContextType: TimeContextType) {
        let timePickerVC = TimePickerViewController()
        timePickerVC.modalPresentationStyle = .custom
        timePickerVC.modalTransitionStyle = .crossDissolve
        
        timePickerVC.delegate = self
        timePickerVC.timeContextType = timeContextType
        
        present(timePickerVC, animated: true, completion: nil)
    }
}

//MARK: - Time Picker View Delegate Methods

extension CreateToDoViewController: TimePickerViewControllerDelegate {
    func timePickerViewDidSet(_ timePickerViewConroller: TimePickerViewController, timeContextType: TimeContextType, timeSet: Date) {
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
    
    func timePickerViewDidCancel(_ timePickerViewController: TimePickerViewController) {
        dismiss(animated: true, completion: nil)
        
        self.addStartTimeTextField.isEnabled = true
        self.addEndTimeTextField.isEnabled = true
    }
}
