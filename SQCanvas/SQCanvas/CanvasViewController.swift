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
    
    func takePhotoFromCamera(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func takeImageFromGallery(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

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
        
    }
}
