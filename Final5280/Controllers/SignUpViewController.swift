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


class SignUpViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
   
    var ref: DatabaseReference!
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        imagePicker.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        ref = Database.database().reference()
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
        
        let user = User()
        user.email = email.text!
        user.firstName = firstName.text!
        user.lastName = lastName.text!
        user.profilePicture = ""
        
        
        Auth.auth().createUser(withEmail: user.email!, password: password.text!) { (result, error) in
            if(result != nil){
                print(result?.user.uid)
                user.userId = result?.user.uid
                self.ref.child("Users").child(user.userId!).setValue(["userId" : user.userId , "firstName" : user.firstName , "lastName" : user.lastName , "profilePicture" : user.profilePicture, "email" : user.email])
            }
            
            if(error != nil){
                print(error!)
            }
        }
        
        
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

extension SignUpViewController: UITextFieldDelegate{
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
