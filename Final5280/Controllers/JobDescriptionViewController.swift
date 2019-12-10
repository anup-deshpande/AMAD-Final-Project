//
//  JobDescriptionViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 12/9/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class JobDescriptionViewController: UIViewController {

    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var reqNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var interestedUsersTableView: UITableView!
    
    var jobToDisplay: job?
    var ref: DatabaseReference!
    var userRef: DatabaseReference!
    var observeReference: DatabaseReference!
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interestedUsersTableView.delegate = self
        interestedUsersTableView.dataSource = self
        
        // setup initial values
        setupValues()
        
        // Initialize firebase database reference
        ref = Database.database().reference()
        userRef = Database.database().reference()
        
        // Setup Listener for interested users
        let userID = Auth.auth().currentUser?.uid
        ref = ref.child("Users").child(userID!).child("createdJobs").child("\(jobToDisplay!.id!)").child("InterestedUsers")
        
        ref.observe(.value) { (snapshot) in
            
            // Clear table view data before adding new
            self.users.removeAll()
            
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                
                guard let dict = snap.value as? [String:Any?] else{return}
                
                let user = User()
                user.userId = snap.key
                user.bidPrice = dict["bidPrice"] as? String
                let name = dict["userName"] as? String
                user.firstName = "\(name!.split(separator: " ").first!)"
                user.lastName = "\(name!.split(separator: " ").last!)"
                self.users.append(user)
            }
            
            self.interestedUsersTableView.reloadData()
            
        }
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
        commentsLabel.text = jobToDisplay?.comments!
        
    }
    
    
    func didSelectUser(at index: Int){
        print(users[index].userId)
        let userID = Auth.auth().currentUser?.uid
        
        // Add selected user in created jobs
        ref = Database.database().reference()
        ref = ref.child("Users").child(userID!).child("createdJobs").child("\(jobToDisplay!.id!)")
        ref.child("acceptedUserID").setValue("\(users[index].userId!)")
        ref.child("acceptedUserName").setValue("\(users[index].firstName!) \(users[index].lastName!)")
        
        // TODO: Update price
        
        // Remove Interested Users
        ref = Database.database().reference()
        ref = ref.child("Users").child(userID!).child("createdJobs").child("\(jobToDisplay!.id!)").child("InterestedUsers")
        ref.removeValue()
        
        
        // TODO: Copy new job object to ongoing jobs of selected user
        
        // TODO: Remove job from job pool
        
        // TODO: Update UI
        
        
    }

}

// MARK: interestedUsersTableView delegate methods
extension JobDescriptionViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.didSelectUser(at: indexPath.row)
    }
}


extension JobDescriptionViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "interestedUsersCell", for: indexPath) as! interestedUserTableViewCell
        
        cell.userNameLabel.text = users[indexPath.row].firstName! + " " + users[indexPath.row].lastName!
        cell.bidPriceLabel.text = "$" + users[indexPath.row].bidPrice!
        
        return cell
    }
    
    
}
