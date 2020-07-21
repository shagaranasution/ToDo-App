//
//  ToDoViewController+CollectionView.swift
//  ToDo
//
//  Created by Shagara F Nasution on 08/07/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

//MARK: - Day Collection View Data Configuration

extension ToDoViewController: UICollectionViewDataSource {
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

//MARK: - Collection View Delegate Methods

extension ToDoViewController: UICollectionViewDelegate {
    func setupCollectionViewLayout() {
        guard let flowLayout = dayCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let height = dayCollectionView.frame.height - 8
        let width: CGFloat = 40
        
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dayCollectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! FullDateCollectionViewCell
        
        let date = dates[indexPath.row]
        
        cell.populateItem(date: date, includesMonth: true)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            let offset = CGPoint(x: cell.center.x - collectionView.frame.width / 2, y: 0)
            collectionView.setContentOffset(offset, animated: true)
        }
        
        let selectedDate = dates[indexPath.row]
        
        self.selectedDate = selectedDate
        showRightBarButtonItem()
        
        setNavigationItemTitle(with: selectedDate)
        loadItems(date: selectedDate)
    }
}
