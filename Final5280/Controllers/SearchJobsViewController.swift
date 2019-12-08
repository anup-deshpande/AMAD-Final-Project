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
    var jobList : [ String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        searchJobTableView.delegate = self
        searchJobTableView.dataSource = self
    }
    
    func readJobList() -> [String]
    {
        self.jobList = []
        
        self.ref.child("jobs").observe(DataEventType.value) { (snapshot) in
            
        }
        
        return self.jobList
        
    }
    
}
extension SearchJobsViewController : UITableViewDelegate{
    
}

extension SearchJobsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "searchJobTableViewCell", for: indexPath) as! SearchJobTableViewCell
        return cell
    }
}


