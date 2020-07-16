//
//  ToDoCell.swift
//  ToDo
//
//  Created by Shagara F Nasution on 18/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import UIKit
import SwipeCellKit

class ToDoCell: SwipeTableViewCell {

    @IBOutlet weak var toDoTitle: UILabel!
    @IBOutlet weak var activityDate: UILabel!
    @IBOutlet weak var contentWrapperView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentWrapperView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
