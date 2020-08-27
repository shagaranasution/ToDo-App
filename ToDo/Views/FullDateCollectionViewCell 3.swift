//
//  FullDateCollectionViewCell.swift
//  ToDo
//
//  Created by Shagara F Nasution on 08/07/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

class FullDateCollectionViewCell: UICollectionViewCell {
    
    struct Style {
        static let normalColor: UIColor = .clear
        static let highlightColor: UIColor = UIColor(named: "containerColor")!
    }

    @IBOutlet weak var contentWrapper: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentWrapper.backgroundColor = Style.normalColor
        self.layer.cornerRadius = self.frame.height * 0.2
    }
    
    override var isSelected: Bool {
        didSet {
            contentWrapper.backgroundColor = isSelected == true ? Style.highlightColor : Style.normalColor
        }
    }
    
    func populateItem(date: Date, includesMonth: Bool) {
        let mdateFormatter = DateFormatter()
        mdateFormatter.dateFormat = "MMM"
        mdateFormatter.locale = .current

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        dateFormatter.locale = .current
        dayLabel.text = dateFormatter.string(from: date)

        let numberFormatter = DateFormatter()
        numberFormatter.dateFormat = "d"
        numberFormatter.locale = .current
        numberLabel.text = numberFormatter.string(from: date)
    }
}
