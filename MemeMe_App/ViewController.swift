//
//  ViewController.swift
//  MemeMe_App
//
//  Created by Richard Lipski on 24.01.21.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {


//  imagePickerView
    @IBOutlet weak var imagePickerView: UIImageView!
    
    
    
//  pickAnImage Button
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        
        }

    
}

