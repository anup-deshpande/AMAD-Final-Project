//
//  SignUpViewController.swift
//  Final5280
//
//  Created by Adwait Tathe on 11/21/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    let imagePicker = UIImagePickerController()
    var ref: DatabaseReference!
    let storage = Storage.storage()
    var data = Data()
    var metaData = StorageMetadata()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        firstName.delegate = self
        lastName.delegate = self
        email.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        password.isSecureTextEntry = true;
        confirmPassword.isSecureTextEntry = true;
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.imageTapped(gesture:)))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        self.ref = Database.database().reference()
        
    }
    
    func validation() -> Bool
    {
        var flag = true
        if(firstName.text == ""){
            print("Email Cannot be empty");
            flag = false
        }
        if(lastName.text == ""){
            print("Last Name Cannot be empty");
            flag = false
        }
        if(email.text == "")
        {
            print("Password Cannot be empty");
            flag = false
        }
        if(password.text == "")
        {
            print("Confirrm Password Cannot be empty");
            flag = false
        }
        if(confirmPassword.text == "")
        {
            print("Confirrm Password Cannot be empty");
            flag = false
        }
        if(password.text != confirmPassword.text)
        {
            flag = false;
        }
        return flag
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
   
        let user = User()
        user.email = email.text!
        user.firstName = firstName.text!
        user.lastName = lastName.text!
        user.profilePicture = ""
        
        let profileRef = self.storage.reference().child("userProfile").child(UUID().uuidString)
        let uploadTask = profileRef.putData(self.data, metadata: self.metaData) { (metadata, error) in
            if error == nil
            {
                print("success")
                profileRef.downloadURL { (url, error) in
                    user.profilePicture = url?.absoluteString
                    Auth.auth().createUser(withEmail: user.email!, password: self.password.text!) { (result, error) in
                        if(result != nil){
                            user.userId = result?.user.uid
                            self.ref.child("Users").child(user.userId!).setValue(["userId" : user.userId , "firstName" : user.firstName , "lastName" : user.lastName , "profilePicture" : user.profilePicture, "email" : user.email])
                        }
                        if(error != nil){
                            print(error!)
                        }
                        
                    }
                }
            }
            else
            {
                print("ERROR")
                print(error)
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
            self.data = (profilePicture.image?.pngData())!
            self.metaData.contentType = "image/png"
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
