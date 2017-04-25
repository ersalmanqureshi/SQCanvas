//
//  BottomLauncherModel.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 4/26/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import UIKit

class BottomLauncherModel: NSObject {
    var icon: String?
    var title: String?
    
    init(icon: String, title: String) {
        self.icon = icon
        self.title = title
    }
}
