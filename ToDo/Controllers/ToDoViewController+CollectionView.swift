//
//  ToDoViewController+CollectionView.swift
//  ToDo
//
//  Created by Shagara F Nasution on 08/07/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

extension ToDoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
