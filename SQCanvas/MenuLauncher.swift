//
//  MenuLauncher.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 9/18/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//
import UIKit

class MenuLauncher: NSObject {
    
    let blurView = UIView()
    
    let menuItemView: MenuView = {
        let view = MenuView(frame: .zero)
        return view
    }()
    
    func showCanvasView(){
        if let window = UIApplication.shared.keyWindow{
            
            blurView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCanvasDismiss)))
            
            // window.addSubview(blurView)
            window.addSubview(menuItemView)
            
            blurView.frame = window.frame
            blurView.alpha = 0.5
            
            let height: CGFloat = 50
            //let y = -height
            menuItemView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blurView.alpha = 1
                
                self.menuItemView.frame = CGRect(x: 0, y: 20.0, width: self.menuItemView.frame.width, height: self.menuItemView.frame.height)
                
            }, completion: nil)
        }
    }
    
    //dismiss the menu item
    func handleCanvasDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = 0
            self.menuItemView.frame = CGRect(x: 0, y: -70, width: self.menuItemView.frame.width, height: self.menuItemView.frame.height)
        })
    }
    
}
