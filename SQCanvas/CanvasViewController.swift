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
    
    var selectedImage: UIImageView? = nil
    var imageViewLayers: [UIImageView]? = []
    
    //MARK: Lazy Gesture Inittialization
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
    
    lazy var pinchGestureRecognizer: UIPinchGestureRecognizer = { [unowned self] in
        let gesture = UIPinchGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePinchGesture(_:)))
        //gesture.delegate = self
        
        return gesture
    }()
    
    //MARK: View controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set delegate
        bottomLauncher.delegate = self
        canvasViewTapGesture()
    }
    
    //--------------------Canvas View Tap-------------------------
    func canvasViewTapGesture(){
        let canvasTap = UITapGestureRecognizer(target: self, action: #selector(canvasViewTap))
        canvasTap.numberOfTapsRequired = 1
        //canvasTap.delegate = self
        boundaryView.addGestureRecognizer(canvasTap)
    }
    
    func canvasViewTap(){
        self.view.layoutIfNeeded()
        removeBorderFromAll()
        //self.dismissMenuView()
        
    }
    
    
    @IBAction func hanldeLauncher(_ sender: UIBarButtonItem) {
        bottomLauncher.showFloaterView()
    }
    
    // MARK: - Action Tap gesture
    func overlayViewDidTap(_ gesture: UITapGestureRecognizer) {
        
        bringToFrontAndSetBorder(gesture.view!)
        gesture.view!.becomeFirstResponder()
        
        //self.addNewImageViewLayer()
        self.view.layoutIfNeeded()
        //removeBorderFromAll()
       // self.dismissMenuView()
    }
    
    // MARK: - Action Pan gesture recognizer
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: boundaryView)
        gesture.view!.center = CGPoint(x: (gesture.view!.center.x) + translation.x,
                               y: (gesture.view!.center.y) + translation.y)
        gesture.setTranslation(.zero, in: boundaryView)

    }
    
    // MARK: - Action Rotated gesture recognizer
    func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        gesture.view!.transform = gesture.view!.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }

    // MARK: - Action Pinch gesture recognizer
    func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        let scale = gesture.scale
        
        gesture.view!.bounds = CGRect(x: 0, y: 0, width: (gesture.view?.bounds.width)! * scale, height: (gesture.view?.bounds.width)! * scale)//gesture.view!.transform.rotated(by: gesture.rotation)
        gesture.scale = 1
    }
    
    func setupGesturesdOnImage(_ image: UIImage){
     
        let pan_gesture : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.handlePanGesture(_:)))
        let pinch_gesture : UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(CanvasViewController.handlePinchGesture(_:)))
        let rotate_gesture : UIRotationGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(CanvasViewController.handleRotateGesture(_:)))
        let tap_gesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CanvasViewController.overlayViewDidTap(_:)))
        
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
        
        imageView.addGestureRecognizer(pan_gesture)
        imageView.addGestureRecognizer(pinch_gesture)
        imageView.addGestureRecognizer(rotate_gesture)
        imageView.addGestureRecognizer(tap_gesture)
        imageView.layer.allowsEdgeAntialiasing = true

        selectedImage = imageView
        addImageToBoundarySubView(imageView)
        
    }
    
    func addImageToBoundarySubView(_ imageView: UIImageView) {
//         var actualsize = imageView.frame
//         actualsize.origin = CGPoint(x: boundaryView.center.x - actualsize.width/2, y: boundaryView.center.y - actualsize.height/2)
        
         imageViewLayers!.append(imageView)
         boundaryView.addSubview(imageView)
        
         bringToFrontAndSetBorder(imageView)
    }
    
    func bringToFrontAndSetBorder(_ view : UIView) {
        
        let imageView = view as! UIImageView
        //called when image is tapped
        for i in 0..<imageViewLayers!.count{
            if(imageViewLayers?[i] == imageView){
                imageViewLayers?.remove(at: i)
                break
            }
        }
        
        imageViewLayers?.append(imageView)

        setImageBorder(imageView)
        makeImageViewsTransparent()
        
        
        // view.superview!.bringSubviewToFront(view)
        navigationController?.navigationBar.sendSubview(toBack: imageView)
        imageView.layer.zPosition = -1
        imageView.layer.borderWidth = 2
        imageView.alpha = 1.0
    }
    
    func setImageBorder(_ imageView: UIImageView) {
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 2
        imageView.alpha = 1
        selectedImage = imageView
    }
    
    //Remove Border
    func removeBorderFromAll(){
        for imageView in imageViewLayers!{
            
            if imageView.image == nil {
                imageView.layer.borderColor = UIColor.black.cgColor
            } else {
                imageView.layer.borderColor = UIColor.clear.cgColor
            }
            imageView.alpha = 1
        }
    }
    
    func makeImageViewsTransparent(){  //similar to polyvore

        for i in 0..<imageViewLayers!.count{
            
            let image = imageViewLayers![i]
            image.alpha = 0.4
            image.layer.borderColor = UIColor.clear.cgColor
            
        }
    }
    
    
    //MARK: Selection from camera or gallery
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
