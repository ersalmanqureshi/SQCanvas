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
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    
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
    
    //MARK: Undo & Redo Observer declaration
    let undoer = UndoManager()
    var undoDidCloseGroupObserver: NCObserver!
    var undoDidUndoChangeObserver: NCObserver!
    var undoDidRedoChangeObserver: NCObserver!
    
    let kTransformScaleSmall = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
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
        boundaryView.addGestureRecognizer(canvasTap)
    }
    
    func canvasViewTap(){
        self.view.layoutIfNeeded()
        removeBorderFromAll()
    }
   
    @IBAction func handleUndoButton(_ sender: UIButton) {
         self.undoer.undo()
    }
    
    @IBAction func handleRedoButton(_ sender: UIButton) {
         self.undoer.redo()
    }
    
    
    @IBAction func handleCenterButton(_ sender: UIButton) {
    }
    
//    func removeImage(fromArray image: UIImageView) {
//        
//        for i in 0..<self.imageViewLayers!.count {
//            
//            
//            if let image = self.imageViewLayers?[i] {
//                
//                if image == selectedImage {
//                    self.imageViewLayers!.remove(at: i)
//                    self.registerUndoRemoveFigure(image)
//                    
//                    let actualFrame = image.bounds
//                    
//                    UIView.animate(withDuration: 0.5, animations: {
//                        
//                        image.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
//                        // image.transform = CGAffineTransformRotate(image.transform, 180)
//                        
//                    }, completion:{ (Bool) in
//                        image.bounds = actualFrame
//                        image.removeFromSuperview()
//                        
//                    })
//                }
//                //self.dismissMenuView()
//                self.removeBorderFromAll()
//            }
//        }
//        
//        self.undoButton.isEnabled = undoer.canUndo == true
//        self.redoButton.isEnabled = undoer.canRedo == true
//    }
    
    func moveImage(_ image: UIImageView, center: CGPoint) {
        self.registerUndoMoveFigure(image)
        
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
            image.center = center
        }, completion: nil)
        
        self.undoButton.isEnabled = undoer.canUndo == true
        self.redoButton.isEnabled = undoer.canRedo == true
        //self.checkStatusOfCenterButton()
        
        
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
        
        let imgView = gesture.view! as? UIImageView
        
        let state = gesture.state
        if state == .began {
            self.undoer.beginUndoGrouping()
            self.registerUndoMoveFigure(imgView!)
        }
        if state == .began || state == .changed {
            
            let translation = gesture.translation(in: boundaryView)
            gesture.view!.center = CGPoint(x: (gesture.view!.center.x) + translation.x,
                                           y: (gesture.view!.center.y) + translation.y)
            gesture.setTranslation(.zero, in: boundaryView)
            
        } else if state == .ended {
            
            //self.checkIfTODeleteImage(imgView, gesture: gesture)
            //self.updateUndoAndRedoButtons()
            self.undoer.endUndoGrouping()
            
            self.undoButton.isEnabled = undoer.canUndo == true
            self.redoButton.isEnabled = undoer.canRedo == true
            
            //self.checkStatusOfCenterButton()\
        }
    }
    
    // MARK: - Action Rotated gesture recognizer
    func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        
        let imgView: UIImageView = gesture.view as! UIImageView
        
        let state = gesture.state
        if state == .began {
            
            self.undoer.beginUndoGrouping()
            self.setUndoForRotate(imgView)
    
            //  self.moveFigure(imgView!, gesture: recognizer)
        }
        
        if state == .began || state == .changed {
            gesture.view!.transform = gesture.view!.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
            //setRotateTransform(imgView, recognizer: gesture)
        }
        else if state == .ended {
            
            // imgView!.transform = originalImageViewTransform!
            self.undoer.endUndoGrouping()
            self.becomeFirstResponder()
            
            self.undoButton.isEnabled = undoer.canUndo == true
            self.redoButton.isEnabled = undoer.canRedo == true
            
            //self.checkStatusOfCenterButton()
        }
    }
    
    func setUndoForRotate(_ imgView: UIImageView){
        
        (undoer.prepare(withInvocationTarget: self) as AnyObject).undoRotateTransform(imgView, transform: imgView.transform)
        undoer.setActionName("rotate")
    }
    
    //rotate undo transform
    func undoRotateTransform(_ view : UIImageView, transform : CGAffineTransform){
        
        self.setUndoForRotate(view)
        
        if (undoer.isUndoing || undoer.isRedoing) {
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
                view.transform = transform
            }, completion: nil)
        }
        
        self.undoButton.isEnabled = undoer.canUndo == true
        self.redoButton.isEnabled = undoer.canRedo == true
        
       // self.checkStatusOfCenterButton()
    }

    // MARK: - Action Pinch gesture recognizer
    func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
      
        let imgView = gesture.view! as? UIImageView
        
        print("pinch called!!")
        
        let state = gesture.state
        if state == .began {
            
            self.undoer.beginUndoGrouping()
            self.setUndoForScale(imgView!)
            //  self.moveFigure(imgView!, gesture: recognizer)
        }
        if state == .began || state == .changed {
            let scale = gesture.scale
            
            gesture.view!.bounds = CGRect(x: 0, y: 0, width: (gesture.view?.bounds.width)! * scale, height: (gesture.view?.bounds.width)! * scale)//gesture.view!.transform.rotated(by: gesture.rotation)
            gesture.scale = 1
        }
        else if state == .ended {
            
            //imgView!.transform = originalImageViewTransform!
            self.undoer.endUndoGrouping();
            self.becomeFirstResponder()
            
            self.undoButton.isEnabled = undoer.canUndo == true
            self.redoButton.isEnabled = undoer.canRedo == true
            
            //self.checkStatusOfCenterButton()
        }
        
    }

    func setUndoForScale(_ imgView: UIImageView){
        
        (undoer.prepare(withInvocationTarget: self) as AnyObject).undoScaleTransform(imgView, frame: imgView.bounds)
        
        undoer.setActionName("scale")
    }
    
    //scale undo transform
    
    func undoScaleTransform(_ view : UIImageView, frame : CGRect){
        
        self.setUndoForScale(view)
        
        if (undoer.isUndoing || undoer.isRedoing) {
            UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
                view.bounds  = frame
            }, completion: nil)
        }
        
        
        self.undoButton.isEnabled = undoer.canUndo == true
        self.redoButton.isEnabled = undoer.canRedo == true
        //self.checkStatusOfCenterButton()
        
        
        //        self.registerUndoMoveFigure(image)
        //
        //
        //        UIView.animateWithDuration(0.4, delay: 0.1, options: [], animations: {
        //            image.center = center
        //            }, completion: nil)
        //
        //        self.undoButton.enabled = undoer.canUndo == true
        //        self.redoButton.enabled = undoer.canRedo == true
        //
        
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
         self.registerUndoAddFigure(imageView)
        
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
    
    // ================================
    // MARK: - Redo / Undo
    
    func registerUndoAddFigure(_ image: UIImageView) {
        (undoer.prepare(withInvocationTarget: self) as AnyObject).addImageToBoundarySubView( image)
        undoer.setActionName("Add Figure")
    }
    
    //    func registerUndoRemoveFigure(_ imageView: UIImageView) {
    //        (undoer.prepare(withInvocationTarget: self) as AnyObject).addImageToBoundarySubView(imageView)
    //        undoer.setActionName("Remove Figure")
    //    }
    
    //Register Undo Move Figure
    func registerUndoMoveFigure(_ image: UIImageView) {
        (undoer.prepare(withInvocationTarget: self) as AnyObject).moveImage(image, center: image.center)
        undoer.setActionName("Move to \(image.center.x) , \(image.center.y)")
        
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
