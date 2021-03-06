//
//  MenuView.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 9/18/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import Foundation

import UIKit

class MenuView: UIView {
    
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
    @IBOutlet weak var flopButtonTap: UIButton!
    @IBOutlet weak var forwardButtonTap: UIButton!
    @IBOutlet weak var backwardButtonTap: UIButton!    
    
    func xibSetup() {
        
        Bundle.main.loadNibNamed("Menu", owner: self, options: nil)?[0] as? UIView
        self.addSubview(view)
        view.addSubview(deleteButtonTap)
        view.addSubview(cloneButtonTap)
        view.addSubview(flopButtonTap)
        view.addSubview(flipButtonTap)
        view.addSubview(forwardButtonTap)
        view.addSubview(backwardButtonTap)
        view.frame = self.bounds
        
    }
}
