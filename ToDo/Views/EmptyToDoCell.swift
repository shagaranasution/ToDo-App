//
//  EmptyToDoCell.swift
//  ToDo
//
//  Created by Shagara F Nasution on 24/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit

class EmptyToDoCell: UITableViewCell {
    
    @IBOutlet weak var contentWrapperView: UIView!
    var height: CGFloat?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let heightConstraint = NSLayoutConstraint(item: contentWrapperView!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: screenHeight * 0.5)
        
        contentWrapperView.addConstraint(heightConstraint)
        contentWrapperView.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
