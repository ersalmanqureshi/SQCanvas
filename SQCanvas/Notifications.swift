//
//  Notifictions.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 9/17/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import UIKit
import Foundation

enum NotificationName: String {
    
    case DidCloseUndoGroupNotification = "DidCloseUndoGroupNotification"
    case DidUndoChangeNotification = "DidUndoChangeNotification"
    case DidRedoChangeNotification = "DidRedoChangeNotification"
    
    var string: String {
        switch self {
        case .DidCloseUndoGroupNotification: return NSNotification.Name.NSUndoManagerDidCloseUndoGroup.rawValue
        case .DidUndoChangeNotification: return NSNotification.Name.NSUndoManagerDidUndoChange.rawValue
        case .DidRedoChangeNotification: return NSNotification.Name.NSUndoManagerDidRedoChange.rawValue
        }
    }
}

class Notifications {
    class var notificationCenter: NotificationCenter {
        return NotificationCenter.default
    }
    
    class func addObserver(_ observer: AnyObject, selector: Selector, name: NotificationName, object: AnyObject? = nil) {
        notificationCenter.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name.string), object: object)
    }
    
    class func postNotification(_ name: NotificationName, object: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
        notificationCenter.post(name: Notification.Name(rawValue: name.string), object: object, userInfo: userInfo)
    }
    
    class func removeObserver(_ observer: AnyObject, name: NotificationName? = nil, object: AnyObject? = nil) {
        notificationCenter.removeObserver(observer, name: (name?.string).map { NSNotification.Name(rawValue: $0) } ?? nil, object: object)
    }
}
