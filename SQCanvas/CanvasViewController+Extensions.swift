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

extension CanvasViewController {
    
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
}
