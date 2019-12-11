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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref =  Database.database().reference()
        setupValues()
    }
    
    func setupValues(){
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
        priceLabel.text = jobToDisplay?.price!
        statusLabel.text = jobToDisplay?.status!
        userNameLabel.text = jobToDisplay?.acceptedUserName!
        self.setProfilePicture(jobToDisplay?.acceptedUserId!)
        
    }
    
    func  setProfilePicture(_ userId : String?)  {
        
        self.ref.child("Users").child(userId!).child("profilePicture").observeSingleEvent(of: .value) { (snapshot) in
            //self.jobImage.kf.setImage(with: URL(fileURLWithPath: snapshot.value! as! String))
            self.userImage.kf.setImage(with: URL(string: snapshot.value! as! String))
        }
    }
    
    @IBAction func didTapMakePayment(_ sender: UIButton) {
    }
    
}
