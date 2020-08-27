//
//  Item.swift
//  ToDo
//
//  Created by Shagara F Nasution on 24/06/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var startDateTime: Date = Date()
    @objc dynamic var finishDateTime: Date = Date()
}
