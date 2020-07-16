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
    @IBOutlet weak var toDoListView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var addToDo: UITabBarItem!
    
    var rightBarButtonItem: UIBarButtonItem?
    
    public let realm = try! Realm()
    
    public var calender: Calendar = .current
    let dateFormatter = DateFormatter()
    
//    var tomorrowDate = Date().addingTimeInterval(60 * 60 * 24 * 1)
//    var yesterdayDate = Date().addingTimeInterval(-60 * 60 * 24 * 1)
    var selectedDate: Date?
    var isRightBarButtonItemShow = false
    
    var toDoItems: Results<Item>?
    var dates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupCollectionViewLayout()
        
        dayCollectionView.dataSource = self
        dayCollectionView.delegate = self
        toDoListView.dataSource = self
        tabBar.delegate = self
        
        dayCollectionView.register(UINib(nibName: "FullDateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "dayCell")
        toDoListView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
        toDoListView.register(UINib(nibName: "EmptyToDoCell", bundle: nil), forCellReuseIdentifier: "reuseEmptyToDoCell")
        
        loadItems(date: Date())
    }
    
    func loadItems(date: Date) {
        let dateFormatter = DateFormatter()
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
    
    func configureView() {
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
        updateCollectionView()
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

//        let strCurrentDate = dateFormatter.string(from: currentDate)
//        let strTomorrowDate = dateFormatter.string(from: tomorrowDate)
//        let strYesterdayDate = dateFormatter.string(from: yesterdayDate)
//        let strDate = dateFormatter.string(from: date)
//
//        switch strDate {
//        case strCurrentDate:
//            self.navigationItem.title = "Today"
//        case strTomorrowDate:
//            self.navigationItem.title = "Tomorrow"
//        case strYesterdayDate:
//            self.navigationItem.title = "Yesterday"
//        default:
//            self.navigationItem.title = dateFormatter.string(from: date)
//        }
        let navigationTitleModel = NavigationTitleModel(currentDate: currentDate, selectedDate: date, dateFormatter: dateFormatter)
        self.navigationItem.title = navigationTitleModel.dayTitle
    }
    
    @objc func onRightBarButtonItemPressed() {
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

//MARK: - Day Collection View Data Configuration

extension ToDoViewController {
    func fillDates() {
        var dates: [Date] = []
        var days = DateComponents()
        var dayCount = 0
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let minDate = Date().addingTimeInterval(-123456789.0)
        let maxDate = Date().addingTimeInterval(123456789.0)

        repeat {
            days.day = dayCount
            dayCount += 1
            
            guard let date = calender.date(byAdding: days, to: minDate) else {
                break;
            }
            
            if date.compare(maxDate) == .orderedDescending {
                break
            }
            
            let stringDate = dateFormatter.string(from: date)
            
            guard let formattedDate = dateFormatter.date(from: stringDate) else {
                return
            }
            
            dates.append(formattedDate)
        } while (true)
        
        self.dates = dates
        
        self.dayCollectionView.reloadData()

        let stringCurrentDate = dateFormatter.string(from: Date())
        guard let formattedStringCurrentDate = dateFormatter.date(from: stringCurrentDate) else {
            return
        }
    
        for i in 0..<self.dates.count {
            let date = self.dates[i]
            
            if date.compare(formattedStringCurrentDate) == .orderedSame {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.dayCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .centeredHorizontally)
                })
            }
        }
    }
    
    func updateCollectionView() {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        for i in 0..<dates.count {
            let date = dates[i]
            
            if dateFormatter.string(from: date) == dateFormatter.string(from: currentDate) {
                let indexPath = IndexPath(row: i, section: 0)
                
                dayCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.dayCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                })
                
                break
            }
        }
    }
}
