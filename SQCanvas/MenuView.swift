//
//  MenuView.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 9/18/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import Foundation

import UIKit

class MenuItemView: UIView {
    
    @IBOutlet var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    @IBOutlet weak var deleteButtonTap: UIButton!
    @IBOutlet weak var flipButtonTap: UIButton!
    @IBOutlet weak var cloneButtonTap: UIButton!
    @IBOutlet weak var cutoutButtonTap: UIButton!
    @IBOutlet weak var forwardButtonTap: UIButton!
    @IBOutlet weak var backwardButtonTap: UIButton!    
    
    func xibSetup() {
        
        Bundle.main.loadNibNamed("Menu", owner: self, options: nil)?[0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
    }
}
