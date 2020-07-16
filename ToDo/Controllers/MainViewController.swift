//
//  MainViewController.swift
//  ToDo
//
//  Created by Shagara F Nasution on 17/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var toDoListView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var addToDo: UITabBarItem!
    
    public let realm = try! Realm()
    
    public var calender: Calendar = .current
    
    private var currentDate = Date()
    private var tomorrowDate = Date().addingTimeInterval(60 * 60 * 24 * 1)
    private var yesterdayDate = Date().addingTimeInterval(-60 * 60 * 24 * 1)
    var selectedDate: Date?
    
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
        
        loadItems(date: currentDate)
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
        
        setNavigationItemTitle(with: currentDate)
        
        let configAddToDoIcon = UIImage.SymbolConfiguration(pointSize: 45, weight: .regular, scale: .default)
        
        let addToDoIcon =  UIImage(systemName: "plus.circle.fill", withConfiguration: configAddToDoIcon)
        
        addToDo.image = addToDoIcon?.withTintColor(#colorLiteral(red: 0.9254901961, green: 0.3843137255, blue: 0.3725490196, alpha: 1), renderingMode: .alwaysOriginal)
        
        //fill date
        fillDates()
        updateCollectionView()
    }
    
    func setNavigationItemTitle(with date: Date) {
        print("calling setNavigationItemTitle", date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        
        let strCurrentDate = dateFormatter.string(from: currentDate)
        let strTomorrowDate = dateFormatter.string(from: tomorrowDate)
        let strYesterdayDate = dateFormatter.string(from: yesterdayDate)
        let strDate = dateFormatter.string(from: date)
        
        switch strDate {
        case strCurrentDate:
            DispatchQueue.main.async {
                self.navigationItem.title = "Today"
            }
        case strTomorrowDate:
            DispatchQueue.main.async {
                self.navigationItem.title = "Tomorrow"
            }
        case strYesterdayDate:
            DispatchQueue.main.async {
                self.navigationItem.title = "Yesterday"
            }
        default:
            DispatchQueue.main.async {
                self.navigationItem.title = dateFormatter.string(from: date)
            }
        }
    }
}

//MARK: - CreateToDoVC Delegate Methods

extension MainViewController: CreateToDoViewControllerDelegate {
    func didCreateToDo(_ createToDoViewController: CreateToDoViewController) {
        createToDoViewController.dismiss(animated: true, completion: nil)
        
        toDoListView.reloadData()
    }
}

//MARK: - Day Collection View Data Configuration

extension MainViewController {
    func fillDates() {
        var dates: [Date] = []
        var days = DateComponents()
        
        var dayCount = 0
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy/MM/dd"
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
            
            dates.append(date)
        } while (true)
        
        self.dates = dates
        dayCollectionView.reloadData()
        
        if let index = self.dates.firstIndex(of: currentDate) {
            dayCollectionView.selectItem(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func updateCollectionView() {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        
        for i in 0..<dates.count {
            let date = dates[i]
            if formatter.string(from: date) == formatter.string(from: currentDate) {
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
