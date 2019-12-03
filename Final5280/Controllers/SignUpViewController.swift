//
//  SignUpViewController.swift
//  Final5280
//
//  Created by Adwait Tathe on 11/21/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore

class SignUpViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
   
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FirebaseApp.configure()
        let db = Firestore.firestore()
        
        imagePicker.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.imageTapped(gesture:)))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
 
    }
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true)

        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        print(firstName.text!);
        print(lastName.text!);
        print(email.text!);
        print(password.text!);
        print(confirmPassword.text!);
        
        
        
    }

}

extension SignUpViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            profilePicture.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}
