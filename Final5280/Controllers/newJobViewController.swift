//
//  newJobViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 12/6/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import CoreLocation

class newJobViewController: UIViewController {
    
    @IBOutlet weak var clickImage: UIImageView!
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var jobDescTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var commentsTextField: UITextField!
    
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    let storage = Storage.storage()
    var data = Data()
    var metaData = StorageMetadata()
    // job location
    var latitude: String?
    var longtitude: String?
    var isJobPhoto: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Assign all textField delegates
        jobTitleTextField.delegate = self
        jobDescTextField.delegate = self
        priceTextField.delegate = self
        commentsTextField.delegate = self
        self.isJobPhoto = false
        // Set Minimum date to today in the datepicker
        DatePicker.minimumDate = Date()
        
        // Add tap gesture to clickImage
        let tapClickImage = UITapGestureRecognizer(target: self, action: #selector(tappedClickImage))
        clickImage.isUserInteractionEnabled = true
        clickImage.addGestureRecognizer(tapClickImage)
        
        //Initialize firebase database reference
        self.ref = Database.database().reference()
        self.userRef = Database.database().reference()
        
        
    }
    
    @objc func tappedClickImage(_ sender: UITapGestureRecognizer){
        
        // Make sure that device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            // setup and present camera
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapLocationText(_ sender: UITextField) {
        locationTextField.resignFirstResponder()
        // Show autocomplete controller
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSubmit(_ sender: UIButton) {
        // Check for input validity
        if isEverythingValid(){
            if(self.isJobPhoto!)
            {
                // TODO: Store the image in Firebase storage
                let jobRef = self.storage.reference().child("jobImage").child(UUID().uuidString)
                
                jobRef.putData(self.data, metadata: self.metaData) { (metadata, error) in
                    if error == nil
                    {
                        print("success")
                        
                        jobRef.downloadURL { (url, error) in
                            self.ref = self.ref.child("jobs")
                            self.userRef = self.userRef.child("Users").child("\(Auth.auth().currentUser!.uid)").child("createdJobs")
                            let newRecordRef = self.ref.childByAutoId()
                            let newJob: [String: Any?] = [
                                "id" : newRecordRef.key!,
                                "requesterId": Auth.auth().currentUser!.uid,
                                "requesterName": Auth.auth().currentUser!.displayName,
                                "image" : url?.absoluteString ?? "",
                                "title": self.jobTitleTextField.text!,
                                "description": self.jobDescTextField.text!,
                                "price": self.priceTextField.text!,
                                "date": "\(self.DatePicker.date)",
                                "location": self.locationTextField.text!,
                                "latitude": self.latitude!,
                                "longitude": self.longtitude!,
                                "comment": self.commentsTextField.text ?? ""
                            ]
                            // Store new job in users created job pool
                            self.userRef.child("\(newRecordRef.key!)").setValue(newJob)
                            // Store new job in general jobs pool
                            newRecordRef.setValue(newJob)
                            // Go back to previous screen
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else
                    {
                        print("ERROR")
                        print(error)
                    }
                }
            }
            else
            {
                self.ref = self.ref.child("jobs")
                self.userRef = self.userRef.child("Users").child("\(Auth.auth().currentUser!.uid)").child("createdJobs")
                let newRecordRef = self.ref.childByAutoId()
                let newJob: [String: Any?] = [
                    "id" : newRecordRef.key!,
                    "requesterId": Auth.auth().currentUser!.uid,
                    "requesterName": Auth.auth().currentUser!.displayName,
                    "title": self.jobTitleTextField.text!,
                    "description": self.jobDescTextField.text!,
                    "price": self.priceTextField.text!,
                    "date": "\(self.DatePicker.date)",
                    "location": self.locationTextField.text!,
                    "latitude": self.latitude!,
                    "longitude": self.longtitude!,
                    "comment": self.commentsTextField.text ?? ""
                ]
                // Store new job in users created job pool
                self.userRef.child("\(newRecordRef.key!)").setValue(newJob)
                // Store new job in general jobs pool
                newRecordRef.setValue(newJob)
                // Go back to previous screen
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            return;
        }
    }
    
    func isEverythingValid() -> Bool{
        var flag = true
        
        if jobTitleTextField.text! == "" {
            self.jobTitleTextField.layer.borderWidth = 1.0
            self.jobTitleTextField.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.jobTitleTextField.layer.cornerRadius = 7
            flag = false
        }
        
        if jobDescTextField.text! == "" {
            self.jobDescTextField.layer.borderWidth = 1.0
            self.jobDescTextField.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.jobDescTextField.layer.cornerRadius = 7
            flag = false
        }
        
        if priceTextField.text! == "" {
            self.priceTextField.layer.borderWidth = 1.0
            self.priceTextField.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.priceTextField.layer.cornerRadius = 7
            flag = false
        }
        
        if locationTextField.text! == "" {
            self.locationTextField.layer.borderWidth = 1.0
            self.locationTextField.layer.borderColor =  #colorLiteral(red: 0.9151673913, green: 0.2175602615, blue: 0.1735651791, alpha: 1)
            self.locationTextField.layer.cornerRadius = 7
            flag = false
        }
        
        
        return flag
    }
}

// MARK: Click image delegate methods
extension newJobViewController:  UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            clickImage.image = image
            self.data = (clickImage.image?.pngData())!
            self.metaData.contentType = "image/png"
            self.isJobPhoto = true
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK: Google places autocomplete code
extension newJobViewController: GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Get the place name from 'GMSAutocompleteViewController',
        // display the name in textField
        
        locationTextField.text = place.name!
        locationTextField.layer.borderWidth = 0
        latitude = "\(place.coordinate.latitude)"
        longtitude = "\(place.coordinate.longitude)"
        
        
        // Dismiss the GMSAutocompleteViewController when something is selected
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
    
}

// MARK: TextField Delegate
extension newJobViewController: UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
