//
//  NSObserver.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 9/17/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import Foundation

typealias InfoDictionary = [AnyHashable: Any]
typealias InfoBlock = (_ userInfo: InfoDictionary) -> Void

class NCObserver: NSObject {
    let name: NotificationName
    let block: InfoBlock
    
    convenience init(name: NotificationName, block: @escaping InfoBlock) {
        self.init(name: name, object: nil, block: block)
    }
    
    init(name: NotificationName, object: AnyObject?, block: @escaping InfoBlock) {
        self.name = name
        self.block = block
        super.init()
        Notifications.addObserver(self, selector: #selector(notification(_:)), name: name, object: object)
    }
    
    func notification(_ notification: Notification) {
        block(notification.userInfo ?? InfoDictionary())
    }
    
    deinit {
        Notifications.removeObserver(self)
    }
}
