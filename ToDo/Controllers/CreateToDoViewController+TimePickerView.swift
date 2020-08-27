//
//  CreateToDoViewController+TimePickerView.swift
//  ToDo
//
//  Created by Shagara F Nasution on 26/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

extension CreateToDoViewController: TimePickerViewControllerDelegate {
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
}
