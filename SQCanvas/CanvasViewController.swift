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
    
    //MARK: Undo & Redo Observers
    func registerObservers() {
        undoDidCloseGroupObserver = NCObserver(name: .DidCloseUndoGroupNotification) { [unowned self] userInfo in
            self.toggleUndo(self.undoer.canUndo)
            self.toggleRedo(self.undoer.canRedo)
            
        }
        
        undoDidUndoChangeObserver  = NCObserver(name: .DidUndoChangeNotification) { [unowned self] userInfo in
            self.toggleUndo(self.undoer.canUndo)
            self.toggleRedo(self.undoer.canRedo)
        }
        
        undoDidRedoChangeObserver  = NCObserver(name: .DidRedoChangeNotification) { [unowned self] userInfo in
            self.toggleUndo(self.undoer.canUndo)
            self.toggleRedo(self.undoer.canRedo)
        }
    }
    
    //MARK: Calling from register observers
    func toggleUndo(_ enabled:Bool) {
        if enabled == true{
            self.showView(undoButton)
        }else{
            self.hideView(undoButton)
        }
    }
    
    func toggleRedo(_ enabled:Bool) {
        
        if enabled == true{
            self.showView(redoButton)
        }else{
            self.hideView(redoButton)
        }
        
    }
    
    // ================================
    // MARK: - Undo Menu
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        
        if action == #selector(undo(_:)){
            return undoer.canUndo
        }
        if action == #selector(redo(_:)){
            return undoer.canRedo
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
    func undo(_:AnyObject?){
        undoer.undo()
    }
    
    func redo(_:AnyObject?){
        undoer.redo()
    }
    
    
    // ============================================
    // MARK: - Animation Helpers
    
    func showView(_ view: UIView) {
        animate(0.3) {
            view.alpha = 1
        }
        spring {
            view.transform = CGAffineTransform.identity
        }
    }
    
    func hideView(_ view: UIView) {
        animate(0.2) {
            view.alpha = 0
            view.transform = self.kTransformScaleSmall
        }
    }
    
    let kTransformScaleSmall = CGAffineTransform(scaleX: 0.8, y: 0.8)
    
    func spring(_ animations: @escaping () -> Void) {
        spring(1.3, damping: 0.28, velocity: 50, animations: animations)
    }
    
    func spring(_ duration: Double, damping: CGFloat, velocity: CGFloat, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .allowUserInteraction, animations: animations, completion: nil)
    }
    
    func animate(_ duration: Double, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: .allowUserInteraction, animations: animations, completion: nil)
    }
    
    func animate(_ duration: Double, delay: Double, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: delay, options: .allowUserInteraction, animations: animations, completion: nil)
    }
    
    
    // ================================
    // MARK: - Redo / Undo
    
    func registerUndoAddFigure(_ image: UIImageView) {
        (undoer.prepare(withInvocationTarget: self) as AnyObject).removeImage(fromArray: image)
        undoer.setActionName("Add Figure")
    }
    
    func registerUndoRemoveFigure(_ imageView: UIImageView) {
        (undoer.prepare(withInvocationTarget: self) as AnyObject).addImageToBoundarySubView(imageView)
        undoer.setActionName("Remove Figure")
    }
    
    //Register Undo Move Figure
    func registerUndoMoveFigure(_ image: UIImageView) {
        (undoer.prepare(withInvocationTarget: self) as AnyObject).moveImage(image, center: image.center)
        undoer.setActionName("Move to \(image.center.x) , \(image.center.y)")
        
    }
   
    @IBAction func handleUndoButton(_ sender: UIButton) {
         self.undoer.undo()
    }
    
    @IBAction func handleRedoButton(_ sender: UIButton) {
         self.undoer.redo()
    }
    
    
    @IBAction func handleCenterButton(_ sender: UIButton) {
    }
    
    func removeImage(fromArray image: UIImageView) {
        
        for i in 0..<self.imageViewLayers!.count {
            
            
            if let image = self.imageViewLayers?[i] {
                
                if image == selectedImage {
                    self.imageViewLayers!.remove(at: i)
                    self.registerUndoRemoveFigure(image)
                    
                    let actualFrame = image.bounds
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        
                        image.bounds = CGRect(x: 0, y: 0, width: 1, height: 1)
                        // image.transform = CGAffineTransformRotate(image.transform, 180)
                        
                    }, completion:{ (Bool) in
                        image.bounds = actualFrame
                        image.removeFromSuperview()
                        
                    })
                }
                //self.dismissMenuView()
                self.removeBorderFromAll()
            }
        }
        
        self.undoButton.isEnabled = undoer.canUndo == true
        self.redoButton.isEnabled = undoer.canRedo == true
    }
    
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
