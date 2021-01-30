//
//  ViewController.swift
//  MemeMe_App
//
//  Created by Richard Lipski on 24.01.21.
//  Update on 25.01.21
//  Update on 26.01.21

import UIKit
import Foundation


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
//let textFieldDelegate = MemeTextFieldDelegate()
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
    
    //  pickAnImageFromLibrary Button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
            let albumController = UIImagePickerController()
            albumController.delegate = self
            albumController.sourceType = .photoLibrary
            present(albumController, animated: true, completion: nil)
            }
    
    // pickAnImageFromCamera Button
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let cameraController = UIImagePickerController()
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
        }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
}
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
           }
    
}

