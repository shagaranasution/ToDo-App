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

enum FormToDo {
    case create
    case update
}

class CreateToDoViewController: UIViewController {
    
    @IBOutlet weak var titleFormLabel: UILabel!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var addStartTimeTextField: UITextField!
    @IBOutlet weak var addEndTimeTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    let realm = try! Realm()
    private let calender: Calendar = .current
    
    var formToDoType: FormToDo = .create
    var toDoItem: Item? {
        didSet {
            taskName = toDoItem!.title
            startDateTime = toDoItem!.startDateTime
            finishDateTime = toDoItem!.finishDateTime
            
            let components = calender.dateComponents([.day, .month, .year], from: toDoItem!.startDateTime)
            
            if let day = components.day, let month = components.month, let year = components.year {
                selectedDay = day
                selectedMonth = month
                selectedYear = year
            }
        }
    }
    
    var selectedDate: Date! {
        didSet {            
            let components = calender.dateComponents([.year, .month, .day], from: selectedDate)
            
            if let year = components.year, let month = components.month, let day = components.day {
                self.selectedYear = year
                self.selectedMonth = month
                self.selectedDay = day
            }
        }
    }
    
    private var selectedYear = 0
    private var selectedMonth = 0
    private var selectedDay = 0
    
    var taskName: String?
    var startDateTime: Date?
    var finishDateTime: Date?
    
    weak var delegate: CreateToDoViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        taskNameTextField.delegate = self
        addStartTimeTextField.delegate = self
        addEndTimeTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            self.taskNameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if let taskName = taskNameTextField.text, let startTime = startDateTime, let finishTime = finishDateTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            let newItem = Item()
            newItem.title = taskName
            
            guard let selectedStartDateTime = setSelectedDateTime(day: selectedDay, month: selectedMonth, year: selectedYear, from: startTime) else {
                return
            }
            
            newItem.startDateTime = selectedStartDateTime
            
            guard let selectedFinishDateTime = setSelectedDateTime(day: selectedDay, month: selectedMonth, year: selectedYear, from: finishTime) else {
                return
            }
            
            newItem.finishDateTime = selectedFinishDateTime
            
            switch formToDoType {
            case .create:
                save(item: newItem)
            case .update:
                update(title: taskName, startDateTime: selectedStartDateTime, finishDateTime: selectedFinishDateTime)
            }
            
            self.delegate?.didCreateToDo(self)
        }
    }
    
    private func save(item: Item) {
        do {
            try realm.write{
                realm.add(item)
            }
        } catch {
            print("Error when saving item, \(error)")
        }
    }
    
    private func update(title: String, startDateTime: Date, finishDateTime: Date) {
        if let item = toDoItem {
            do {
                try realm.write{
                    item.title = title
                    item.startDateTime = startDateTime
                    item.finishDateTime = finishDateTime
                }
            } catch {
                print("Error when updating item, \(error)")
            }
        }
    }
    
    private func update(item: Item) {
        do {
            try realm.write {
                item.title = item.title
            }
        } catch {
            print("Error when updating item, \(error)")
        }
    }
    
    private func configureView() {
        // cutomizing form
        switch formToDoType {
        case .create:
            titleFormLabel.text = "Create \na Task"
        case .update:
            titleFormLabel.text = "Update \nThe Task"
            if let unwrappedTaskName = taskName,
                let unwrappedStartDateTime = startDateTime,
                let unwrappedFinishDateTime = finishDateTime {
                
                taskNameTextField.text = unwrappedTaskName
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeStyle = DateFormatter.Style.short
                addStartTimeTextField.text = dateFormatter.string(from: unwrappedStartDateTime)
                addEndTimeTextField.text = dateFormatter.string(from: unwrappedFinishDateTime)
            }
        }
        
        // customizing task name textfield
        taskNameTextField.makeToDoTextField(placeholder: "Name of the task")
        
        // customizing add start time textfield
        addStartTimeTextField.makeToDoTextField(placeholder: "Add start time")
        
        // customizing add end time text field
        addEndTimeTextField.makeToDoTextField(placeholder: "Add finish time")
        
        // customizing add button
        addButton.layer.cornerRadius = 10.0
    }
    
    private func setSelectedDateTime(day: Int?, month: Int?, year: Int, from date: Date) -> Date? {
        let components = calender.dateComponents([.hour, .minute, .second], from: date)
        
        if let hour = components.hour, let minute = components.hour, let second = components.second {
            var dateComponents = DateComponents()
            dateComponents.day = day
            dateComponents.month = month
            dateComponents.year = year
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.second = second
            
            if let selectedDateTime = calender.date(from: dateComponents) {
                return selectedDateTime
            } else {
                return nil
            }
        }
       
        return nil
    }
}

extension UITextField {
    func makeToDoTextField(placeholder: String) {
        self.layer.borderColor = UIColor(named: "cardColor")?.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)])
    }
}
