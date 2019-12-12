//
//  JobDescriptionViewControllerPayment.swift
//  Final5280
//
//  Created by Adwait Tathe on 12/11/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import Braintree
import BraintreeDropIn
import Alamofire
import SwiftyJSON
import KRProgressHUD

class JobDescriptionViewControllerPayment: UIViewController {

    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var reqNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var makePaymentButton: UIButton!
    
    var jobToDisplay: job?
    var ref: DatabaseReference!
    
    // MARK: API URL declarations
    let BTGetTokenAPI = "http://ec2-54-144-115-37.compute-1.amazonaws.com/token"
    let BTCheckoutAPI = "http://ec2-54-144-115-37.compute-1.amazonaws.com/checkout"
    
    var total:Double = 0
    var braintreeClient: BTAPIClient?
    var customerID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref =  Database.database().reference()
        setupValues()
    }
    
    func setupValues(){
        
        ref =  Database.database().reference()
        ref.child("Users").child(jobToDisplay!.acceptedUserId!).observeSingleEvent(of:.value) { (datasnapshot) in
            
            guard let dict = datasnapshot.value as? [String:Any?] else{return}
            self.customerID = dict["braintreeId"]! as? String
        }
        
        self.title = jobToDisplay?.title!
        
        if let stringURL = jobToDisplay!.image {
            let url = URL(string: stringURL)
            jobImage.kf.setImage(with: url)
        }
        
        reqNameLabel.text = jobToDisplay?.title!
        dateLabel.text = "\(jobToDisplay!.date!.split(separator: " ").first!)"
        locationLabel.text = jobToDisplay?.location!
        if(jobToDisplay?.comments! == "")
        {
            commentsLabel.text = "--"
        }
        else
        {
            commentsLabel.text = jobToDisplay?.comments!
        }
        priceLabel.text = "$ \(jobToDisplay!.price!)"
        statusLabel.text = jobToDisplay?.status!
        userNameLabel.text = jobToDisplay?.acceptedUserName!
        self.setProfilePicture(jobToDisplay?.acceptedUserId!)
        
        total = Double(jobToDisplay!.price!)!
        
        
    }
    
    func  setProfilePicture(_ userId : String?)  {
        
        ref =  Database.database().reference()
        self.ref.child("Users").child(userId!).child("profilePicture").observeSingleEvent(of: .value) { (snapshot) in
            //self.jobImage.kf.setImage(with: URL(fileURLWithPath: snapshot.value! as! String))
            self.userImage.kf.setImage(with: URL(string: snapshot.value! as! String))
        }
    }
    
    // MARK: - Braintree API Calls
    
    @IBAction func didTapMakePayment(_ sender: UIButton) {
        
        if total > 0{
        fetchClientToken()
        }else{
         
            KRProgressHUD.showError(withMessage: "Error Occured")
        }
        
    }
    
    func fetchClientToken() {
        
     print(customerID! + "cutsomer ID");
        print(BTGetTokenAPI + "BTGetTokenAPI")
     let parameters: [String:String] = [
         "customerId":customerID!
     ]
     
     AF.request(BTGetTokenAPI,
                   method: .post,
                   parameters: parameters,
                encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    self.showDropIn(clientTokenOrTokenizationKey: json["clientToken"].stringValue)
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                }
                
        }
        
        
    }
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print(error ?? "Error Occured")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                print("Result is")
                
                print(result.paymentMethod!.nonce)
                self.postNonceToServer(paymentMethodNonce: result.paymentMethod!.nonce)
            }
            DispatchQueue.main.async {
                controller.dismiss(animated: true, completion: nil)
            }
            
        }
        
        DispatchQueue.main.async {
            self.present(dropIn!, animated: true, completion: nil)
        }
        
    }
    
    
    func postNonceToServer(paymentMethodNonce: String) {
        
        print("nonce : " + paymentMethodNonce)
        let parameters: [String:String] = [
            "nounce":paymentMethodNonce,
            "amount":String(total)
            
        ]
        
        
        
        AF.request(BTCheckoutAPI,
                   method: .post,
                   parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                switch response.result{
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    KRProgressHUD.showSuccess(withMessage: "Payment Successful")
                    
                    self.ref = Database.database().reference()
                    self.ref = self.ref.child("Users").child(Auth.auth().currentUser!.uid).child("paidJobs").child(self.jobToDisplay!.id!)
                    let jobToCopy : [String: Any?] = [
                        
                        "id" : self.jobToDisplay?.id!,
                        "requesterId": self.jobToDisplay?.requesterId!,
                        "requesterName": self.jobToDisplay?.requesterName!,
                        "acceptedUserName": self.jobToDisplay?.acceptedUserName!,
                        "acceptedUserId": self.jobToDisplay?.acceptedUserId!,
                        "title": self.jobToDisplay?.title!,
                        "description": self.jobToDisplay?.description!,
                        "price": self.jobToDisplay?.price!,
                        "date": self.jobToDisplay?.date!,
                        "location": self.jobToDisplay?.location!,
                        "latitude": self.jobToDisplay?.latitiude!,
                        "longitude": self.jobToDisplay?.longitude!,
                        "comment": self.jobToDisplay?.comments ?? ""
                        
                    ]
                    
                    
                    //self.ref.setValue(jobToCopy)
                    
                    
                    self.ref = Database.database().reference()
                    self.ref = self.ref.child("Users").child(Auth.auth().currentUser!.uid).child("createdJobs").child(self.jobToDisplay!.id!)
                    
                    //self.ref.removeValue()
                    
                    self.ref = Database.database().reference()
                    self.ref = self.ref.child("Users").child(self.jobToDisplay!.acceptedUserId!).child("gotPaidJobs").child(self.jobToDisplay!.id!)
                    self.ref.setValue(jobToCopy)
                    
                    
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                }
                
        }
    }
    
}
