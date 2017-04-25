//
//  CanvasViewController.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 4/26/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var boundaryView: UIView!
    
    let bottomLauncher = BottomLauncherView()
    
    //MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set delegate
        bottomLauncher.delegate = self
    }
    
    @IBAction func hanldeLauncher(_ sender: UIBarButtonItem) {
        bottomLauncher.showFloaterView()
    }
}

extension CanvasViewController: BottomLauncherViewDelegate {
    func didPresentViewController(_ index: Int) {
        if index == 0{
            
            bottomLauncher.handleDismiss()
            
            print("Camera")
            
            
        }else if index == 1{
            bottomLauncher.handleDismiss()
            
            print("Gallery")
           
        }else{
            bottomLauncher.handleDismiss()
        }

    }
}



