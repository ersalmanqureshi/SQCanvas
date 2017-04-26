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
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(overlayViewDidTap(_:)))
        //gesture.delegate = self
        return gesture
    }()
    
    lazy var panGestureRecognizer: UIPanGestureRecognizer = { [unowned self] in
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        //gesture.delegate = self
        
        return gesture
    }()
    
    lazy var rotationGestureRecognizer: UIRotationGestureRecognizer = { [unowned self] in
        let gesture = UIRotationGestureRecognizer()
        gesture.addTarget(self, action: #selector(handleRotateGesture(_:)))
        //gesture.delegate = self
        
        return gesture
    }()
    
    //MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set delegate
        bottomLauncher.delegate = self
    }
    
    @IBAction func hanldeLauncher(_ sender: UIBarButtonItem) {
        bottomLauncher.showFloaterView()
    }
    
    // MARK: - Tap gesture recognizer
    func overlayViewDidTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        
    }
    
    // MARK: - Pan gesture recognizer
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: boundaryView)
    
        gesture.view!.center = CGPoint(x: (gesture.view!.center.x) + translation.x,
                               y: (gesture.view!.center.y) + translation.y)

        gesture.setTranslation(.zero, in: boundaryView)

    }
    
    func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        
    }

    
    func setupGesturesdOnImage(_ image: UIImage){
        
     
        var custom_width = image.size.width
        let height_to_width_ratio = image.size.height/image.size.width
        if(image.size.width > boundaryView.bounds.size.width){
            custom_width = boundaryView.bounds.size.width * 0.5
        }
        let custom_height =  height_to_width_ratio * custom_width
        let frame = CGRect(x: 0 , y: (navigationController?.navigationBar.frame.height)! + 20 + 8, width: custom_width, height: custom_height)
        
        
        let imageView = UIImageView(frame: frame)
        
        imageView.image = image
        imageView.center = CGPoint(x: boundaryView.center.x, y: boundaryView.center.y)
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(panGestureRecognizer)
        //imageView.addGestureRecognizer(pinch_gesture)
        imageView.addGestureRecognizer(rotationGestureRecognizer)
        imageView.addGestureRecognizer(tapGestureRecognizer)
        imageView.layer.allowsEdgeAntialiasing = true

        addImageToBoundarySubView(imageView)


    }
    
    func addImageToBoundarySubView(_ imageView: UIImageView) {
         boundaryView.addSubview(imageView)
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
        setupGesturesdOnImage(image)
    }
}
