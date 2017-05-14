//
//  CanvasViewController+Extensions.swift
//  SQCanvas
//
//  Created by Salman Qureshi on 5/14/17.
//  Copyright © 2017 Salman Qureshi. All rights reserved.
//

import UIKit

extension CanvasViewController: BottomLauncherViewDelegate {
    func didPresentViewController(_ index: Int) {
        if index == 0{
            
            bottomLauncher.handleDismiss()
            
            print("Camera")
            takePhotoFromCamera()
            
        }else if index == 1{
            bottomLauncher.handleDismiss()
            
            print("Gallery")
            takeImageFromGallery()
            
        }else{
            bottomLauncher.handleDismiss()
        }
    }
}

extension CanvasViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //---------------ImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!)
    {
        let imgData = NSData(data: UIImageJPEGRepresentation((image), 1)!) as Data
        
        let imageSize: Int = imgData.count
        print("Dimension width:-\(image.size.width) height:- \(image.size.height)\n---------size of image in KB: %f ", imageSize / 1024)
        
        updateImage(image)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateImage(_ image: UIImage) {
        setupGesturesdOnImage(image)
    }
}
