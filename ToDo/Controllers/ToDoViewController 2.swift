//
//  ToDoViewController.swift
//  ToDo
//
//  Created by Shagara F Nasution on 17/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UIViewController {
    
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var toDoListView: UITableView! {
        didSet {
            toDoListView.allowsSelection = true
            toDoListView.delegate = self
            toDoListView.dataSource = self
            
            toDoListView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
            toDoListView.register(UINib(nibName: "EmptyToDoCell", bundle: nil), forCellReuseIdentifier: "reuseEmptyToDoCell")
        }
    }
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var addToDo: UITabBarItem!
    
    private var rightBarButtonItem: UIBarButtonItem?
    
    let realm = try! Realm()
    let dateFormatter = DateFormatter()
    var calender: Calendar = .current
    
    var selectedDate: Date?
    
    var toDoItems: Results<Item>?
    var dates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupCollectionViewLayout()
        
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self

        tabBar.delegate = self
        
        selectedDate = Date()
        
        dayCollectionView.register(UINib(nibName: "FullDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dayCell")
        
        loadItems(date: Date())
    }
    
    func loadItems(date: Date) {
//        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 00:00:00 Z"
        
        let stringFormattedDate = dateFormatter.string(from: date)
        
        guard let formattedDate = dateFormatter.date(from: stringFormattedDate) else {
            return
        }
        
        let dateAfter = formattedDate.addingTimeInterval(60 * 60 * 24 * 1)
        
        let predicate = NSPredicate(format: "startDateTime >= %@ && startDateTime < %@", formattedDate as NSDate, dateAfter as NSDate)
        toDoItems = realm.objects(Item.self).filter(predicate).sorted(byKeyPath: "startDateTime")
    
        toDoListView.reloadData()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(named: "containerColor")
        
        toDoListView.backgroundColor = UIColor(named: "containerColor")
        toDoListView.separatorStyle = .none
       
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        setNavigationItemTitle(with: Date())
        
        rightBarButtonItem = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(onRightBarButtonItemPressed))
        
        let configAddToDoIcon = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .default)
        
        let addToDoIcon =  UIImage(systemName: "plus.circle.fill", withConfiguration: configAddToDoIcon)
        
        addToDo.image = addToDoIcon?.withTintColor(#colorLiteral(red: 0.9254901961, green: 0.3843137255, blue: 0.3725490196, alpha: 1), renderingMode: .alwaysOriginal)
        
        fillDates()
    }
    
    func showRightBarButtonItem() {
        if let selectedDate = self.selectedDate {
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let stringCurrentDate = dateFormatter.string(from: Date())
            let stringSelectedDate = dateFormatter.string(from: selectedDate)

            if stringCurrentDate != stringSelectedDate {
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
    func setNavigationItemTitle(with date: Date) {
        dateFormatter.dateFormat = "d MMM"
        let currentDate = Date()
        let yesterdayDate = currentDate.addingTimeInterval(-60 * 60 * 24 * 1)
        let tomorrowDate = currentDate.addingTimeInterval(60 * 60 * 24 * 1)

        let strCurrentDate = dateFormatter.string(from: currentDate)
        let strYesterdayDate = dateFormatter.string(from: yesterdayDate)
        let strTomorrowDate = dateFormatter.string(from: tomorrowDate)
        let strDate = dateFormatter.string(from: date)

        switch strDate {
        case strCurrentDate:
            self.navigationItem.title = "Today"
        case strTomorrowDate:
            self.navigationItem.title = "Tomorrow"
        case strYesterdayDate:
            self.navigationItem.title = "Yesterday"
        default:
            self.navigationItem.title = dateFormatter.string(from: date)
        }
    }
    
    @objc private func onRightBarButtonItemPressed() {
        let todayDate = Date()
        self.selectedDate = todayDate
        
        updateCollectionView()
        setNavigationItemTitle(with: todayDate)
        showRightBarButtonItem()
        loadItems(date: self.selectedDate!)
    }
}

//MARK: - CreateToDoVC Delegate Methods

extension ToDoViewController: CreateToDoViewControllerDelegate {
    func didCreateToDo(_ createToDoViewController: CreateToDoViewController) {
        createToDoViewController.dismiss(animated: true, completion: nil)
        
        toDoListView.reloadData()
    }
}
