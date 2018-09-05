//
//  ViewController.swift
//  MemeMeApp for Version 2
//
//  Created by Rosario A Robinson on 7/2/18.
//  Copyright © 2018 Rosario Robinson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    //for cameraButton, add IBOutlet from toolbar
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    //memeTextAttributes to stylize
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5]
    
    //cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Code for textfields
        configure(topTextField, with: "TOP")
        configure(bottomTextField, with: "BOTTOM")
        
        imagePickerView.contentMode = .scaleAspectFit
        
        
    }
    
    //to prevent redundant code
    func configure(_ textField: UITextField, with defaultText: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = (imagePickerView.image != nil)
        
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    //Mark: IBAction to choose image
    //Connected to 'Album' button in toolbar
    @IBAction func pickAnImage(_ sender: Any) {
        pickAnImage(from: .photoLibrary)
    }
    
    //Mark: IBAction to open camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(from: .camera)
    }
    
    //to prevent redundant code from camera and album, add func
    func pickAnImage(from sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Mark: imagePickerController for delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //to dismiss image chosen
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        //hide toolbar and navbar
        self.toolBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show toolbar and navbar
        self.toolBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false

        return memedImage
    }
    
    //Mark: Functions for keyboard display
    //get keyboard height from user dictionary
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //had a few issues with keyboard appearing?
    //subscribe to keyboard notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // unsubscribe to keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    //allows keyboard to move frame upwards to show 'BOTTOM' text
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification: notification) * -1
        }
    }
    
    //hides the keyboard
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //created struct for each meme created
    struct Meme {
        var topText = ""
        var botText = ""
        var originalImage: UIImage?
        var memedImage: UIImage?
    }
    
    func save() {
        // Create the meme
        _ = Meme(topText: topTextField.text!, botText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
    }
    
    //generate the meme
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        print("testing share functionality")
        
        //to save the meme
        activityViewController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItemds: [Any]?, error: Error?) -> Void in
            if completed {
                self.save()
            }
        }
    }
    
    
    //to return back to main screen when cancel is pressed in Nav Bar
    @IBAction func cancelButton(_ sender: Any) {
        imagePickerView.image = nil
        shareButton.isEnabled = false
        
    }
    
}

