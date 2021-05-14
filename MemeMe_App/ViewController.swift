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
//  Update on 16.02.21
//  Update on 24.02.21
//  Redesign after comments
//  Update on 21.04.21
//  Update on 12.05.21

import UIKit
import Foundation

//Meme strukturieren
struct Meme {
    var topTextField: String!
    var bottomTextField: String!
    var originalImage: UIImage!
    var memedImage: UIImage!
}

class MemeMeViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    //IBOutlets
    @IBOutlet weak var imagePickedView: UIImageView!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var pickerToolbar: UIToolbar!
    @IBOutlet weak var cancelToolbarButton: UIBarButtonItem!
    @IBOutlet weak var shareOrCancelToolbar: UIToolbar!
    
    //Meme Attribue
    var meme = Meme()
    enum SourceSelection: Int { case album = 0, camera }
    let memeTextAttributes = [
        convertFromNSAttributedStringKey(NSAttributedString.Key.strokeColor) : UIColor.black,
        convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor) : UIColor.white,
        convertFromNSAttributedStringKey(NSAttributedString.Key.strokeWidth): -5.0,
        convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ] as [String : Any]
    
    //override func
    override func viewWillAppear(_ animated: Bool) {
        cameraPickerButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subcribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        topTextField.delegate = self
        bottomTextField.delegate = self
        configureUI()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    //pickImage
    @IBAction func pickImage(_ sender: AnyObject) {
        
        let  controller = UIImagePickerController()
        controller.delegate = self
        
        switch sender.tag {
        case SourceSelection.album.rawValue:
            controller.sourceType = .photoLibrary
        case SourceSelection.camera.rawValue:
            controller.sourceType = .camera
        default:
            let alertController = UIAlertController()
            alertController.title = "Fehler in der App"
            alertController.message = "Ein Fehler ist aufgetreten"
            let okAction = UIAlertAction(title: "Schliessen", style: UIAlertAction.Style.default, handler: {action in self.dismiss(animated: true, completion: nil)})
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        
        present(controller, animated: true, completion: nil)
        
        shareButton.isEnabled = true
    }
    //shareMeme
    @IBAction func shareMeme(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { type, completed, returnedItems, error -> Void in
            if completed {
                self.save()
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    //cancelMeme
    @IBAction func cancelMeme(_ sender: AnyObject) {
        reset()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imagePickedView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        let textSize: CGSize = newText.size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(.font): textField.font!]))
        return textSize.width < textField.bounds.size.width
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "TOP" || textField.text! == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func configureUI() {
        configureText(topTextField)
        configureText(bottomTextField)
        hideShare(true)
    }
    
    func configureText(_ textField: UITextField){
        textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
        textField.textAlignment = NSTextAlignment.center
        switch textField.tag {
        case 0:
            textField.text = "TOP"
        case 1:
            textField.text = "BOTTOM"
        default:
            textField.text = "Fehler"
            let alertController = UIAlertController()
            alertController.title = "Fehler in der App"
            alertController.message = "Ein Fehler ist aufgetreten"
            let okAction = UIAlertAction(title: "Schliessen", style: UIAlertAction.Style.default, handler: {action in self.dismiss(animated: true, completion: nil)})
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func hideUIElements(_ hide: Bool) {
        pickerToolbar.isHidden = hide
        hideShare(hide)
        shareOrCancelToolbar.isHidden = hide
    }
    
    func generateMemedImage() -> UIImage
    {
        hideUIElements(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideUIElements(false)
        
        return memedImage
    }
    
    func hideShare(_ hide: Bool){
        shareButton.isEnabled = !hide
    }
    
    func save() {
        meme = Meme(topTextField: topTextField.text, bottomTextField: bottomTextField.text, originalImage: imagePickedView.image, memedImage: generateMemedImage())
    }
    
    func reset(){
        imagePickedView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
}

private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

private func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

private func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

extension MemeMeViewController {
    func subcribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}
