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

class CreateToDoViewController: UIViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var addStartTimeTextField: UITextField!
    @IBOutlet weak var addEndTimeTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    public let realm = try! Realm()
    public let calender: Calendar = .current
    
    var selectedDate: Date? {
        didSet {
            guard let unwrappedSelectedDate = selectedDate else {
                return
            }
            
            let components = calender.dateComponents([.year, .month, .day], from: unwrappedSelectedDate)
            
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
    
    func configureView() {
        // customizing task name textfield
        taskNameTextField.makeToDoTextField(placeholder: "Name of the task")
        
        // customizing add start time textfield
        addStartTimeTextField.makeToDoTextField(placeholder: "Add start time")
        
        // customizing add end time text field
        addEndTimeTextField.makeToDoTextField(placeholder: "Add finish time")
        
        // customizing add button
        addButton.layer.cornerRadius = 10.0
    }
    
    func setSelectedDateTime(day: Int?, month: Int?, year: Int, from date: Date) -> Date? {
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
