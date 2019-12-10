//
//  SearchJobsViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/27/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase

class SearchJobsViewController: UIViewController {

    @IBOutlet weak var searchJobTableView: UITableView!
    var ref: DatabaseReference!
    var jobList : [job] = []
    var jobObj : job? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        searchJobTableView.delegate = self
        searchJobTableView.dataSource = self
        readJobList();
    }
    
    func readJobList()
    {
        self.ref.child("jobs").observe(DataEventType.value) { (snapshot) in  
            self.jobList = []
            for child in snapshot.children
            {
                if let childSnapshot = child as? DataSnapshot{
                    let dict = childSnapshot.value as? [String: AnyObject]
                    let jb = job()
                    jb.id = "\(dict!["id"]!)"
                    jb.comments = "\(dict!["comment"]!)"
                    jb.date = "\(dict!["date"]!)"
                    jb.expectedPrice = "\(dict!["expectedPrice"]!)"
                    jb.title = "\(dict!["title"]!)"
                    jb.description = "\(dict!["description"]!)"
                    jb.location = "\(dict!["location"]!)"
                    jb.requesterId = "\(dict!["requesterId"]!)"
                    jb.requesterName = "\(dict!["requesterName"]!)"
                    jb.latitiude = "\(dict!["lat"]!)"
                    jb.longitude =  "\(dict!["long"]!)"
                    self.jobList.append(jb);
                }
            }
            self.searchJobTableView.reloadData();
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! DisplayJobViewController
        vc.job = self.jobObj
    }
    
}
extension SearchJobsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.jobObj = self.jobList[indexPath.row]
        performSegue(withIdentifier: "seachJobToJobDisplaySeague", sender: self)
        
    }
}

extension SearchJobsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchJobTableViewCell", for: indexPath) as! SearchJobTableViewCell
        cell.setValue(self.jobList[indexPath.row])
        return cell
    }
}


