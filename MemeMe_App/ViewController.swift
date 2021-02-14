//
//  ViewController.swift
//  MemeMe_App
//
//  Created by Richard Lipski on 24.01.21.
//  Update on 25.01.21
//  Update on 26.01.21
//  Update on 30.01.21
//  Update on 02.02.21
//  Update on 04.02.21
//  Update on 13.02.21

import UIKit
import Foundation


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    var memeImage: UIImage!
    
//Outlets
@IBOutlet weak var imagePickerView: UIImageView!
@IBOutlet weak var bottomToolbar: UIToolbar!
@IBOutlet weak var pickAnImageButton: UIBarButtonItem!
@IBOutlet weak var pickAnImageFromCamera: UIBarButtonItem!
@IBOutlet weak var topToolbar: UIToolbar!
@IBOutlet weak var shareButton: UIBarButtonItem!
@IBOutlet weak var topTextField: UITextField!
@IBOutlet weak var bottomTextField: UITextField!
    
    //hide keyboard on return
    @IBAction func topdone(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func done(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    

    
    //  pickAnImageFromLibrary Button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
            let albumController = UIImagePickerController()
            albumController.delegate = self
            albumController.sourceType = .photoLibrary
            present(albumController, animated: true, completion: nil)
            }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.shareButton.isEnabled = false
        imagePickerView.image = nil
           }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyBoardNotifications()
    }
    
    // pickAnImageFromCamera Button
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
        }
    
    // share Action
       @IBAction func share() {
        memeImage = generateImage()
        let activity = UIActivityViewController(activityItems: [memeImage!], applicationActivities: nil)
        show(activity, sender: self)
        activity.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed){
                self.save()
                return
            }
        }
    }
    
    //Textfields
    func setTextFieldProps(_ textField: UITextField) {
        let textAttributes : [NSAttributedString.Key : Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .strikethroughColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBold", size: 40)!,
            .strokeWidth: -5.0
        ]
        textField.defaultTextAttributes = textAttributes
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .center
        textField.allowsEditingTextAttributes = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
      
        // Keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
      
          // Keyboard will hide
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

           return
        }
      
      // move up the picture
        if bottomTextField.isEditing {
      self.view.frame.origin.y = 0 - keyboardSize.height
        }}

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back aftwer hiding the Keyboard
      self.view.frame.origin.y = 0
    }
    

    
    func unsubscribeToKeyBoardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    func prepareView() {
        
        //Prepare Text fields within image view
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        
        self.setTextFieldProps(self.topTextField)
        self.setTextFieldProps(self.bottomTextField)
        
        //share button settings
        self.shareButton.isEnabled = false
    }
    
    func hideToolbars(_ hide: Bool) {
        topToolbar.isHidden = hide
        bottomToolbar.isHidden = hide
    }

    func generateImage() -> UIImage {
        
        hideToolbars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(false)
        
        return memedImage
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
}
    
    func save() {
    
            _ = Meme(topText: topTextField.text!,
                bottomText: bottomTextField.text!,
                originalImage:imagePickerView.image!,
                memedImage: generateImage())
                }

        struct Meme {
            let topText:String
            let bottomText:String
            let originalImage:UIImage
            let memedImage:UIImage
                    }

    
}

