//
//  BottomLauncherView.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 4/26/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import UIKit

protocol BottomLauncherViewDelegate: class {
    func didPresentViewController(_ index: Int)
}

class BottomLauncherView: NSObject {
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    
    weak var delegate: BottomLauncherViewDelegate?
    
    let arrayOfLaunncher: [BottomLauncherModel] = {
        return [BottomLauncherModel(icon: "camera", title: "Camera"), BottomLauncherModel(icon: "gallery", title: "Gallery")]
    }()
    
    let blurView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    func showFloaterView(){
        if let window = UIApplication.shared.keyWindow{
            blurView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(blurView)
            window.addSubview(collectionView)
            
            let height: CGFloat = 100
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            blurView.frame = window.frame
            blurView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blurView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
                
            }, completion: nil)
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blurView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        })
    }
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(BottomLauncherCell.self, forCellWithReuseIdentifier: cellId)
    }
}

extension BottomLauncherView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfLaunncher.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BottomLauncherCell
        
        let launcher = arrayOfLaunncher[indexPath.item]
        cell.launcher = launcher
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let storyboard = UIStoryboard(name: "Home", bundle: nil)
        switch indexPath.item {
        case 0:
            self.delegate?.didPresentViewController(indexPath.item)
        case 1:
            self.delegate?.didPresentViewController(indexPath.item)
        case 2:
            self.delegate?.didPresentViewController(indexPath.item)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
