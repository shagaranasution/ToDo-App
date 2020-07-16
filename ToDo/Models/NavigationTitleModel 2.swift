//
//  MainModel.swift
//  ToDo
//
//  Created by Shagara F Nasution on 13/07/20.
//  Copyright © 2020 Shagara F Nasution. All rights reserved.
//

import Foundation

struct NavigationTitleModel {
    let currentDate: Date
    let selectedDate: Date
    let dateFormatter: DateFormatter
    
    var strCurrentDate: String {
        return dateFormatter.string(from: currentDate)
    }
    var strSelectedDate: String {
        return dateFormatter.string(from: selectedDate)
    }
    var strYesterdayDate: String {
        let date = currentDate.addingTimeInterval(-60 * 60 * 24 * 1)
        
        return dateFormatter.string(from: date)
    }
    var strTomorrowDate: String {
        let date = currentDate.addingTimeInterval(60 * 60 * 24 * 1)
        
        return dateFormatter.string(from: date)
    }
    var dayTitle: String {
        switch strSelectedDate {
        case strCurrentDate:
            return "Today"
        case strTomorrowDate:
            return "Tomorrow"
        case strYesterdayDate:
            return "Yesterday"
        default:
            return strSelectedDate
        }
    }
}
