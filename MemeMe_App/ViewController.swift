//
//  ViewController.swift
//  MemeMe_App
//
//  Created by Richard Lipski on 24.01.21.
//  Update on 25.01.21

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {


//  imagePickerView
    @IBOutlet weak var imagePickerView: UIImageView!
    
    
    
//  pickAnImage Button
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
         pickerController.allowsEditing = false
         pickerController.delegate = self
             pickerController.sourceType = .photoLibrary

         
         present(pickerController, animated: true, completion: nil)
        
        }

    
}

