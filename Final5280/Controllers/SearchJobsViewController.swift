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
    override func viewDidLoad() {
        super.viewDidLoad()
        let jb = job()
        jb.title = "asd"
        jb.description = "sddsfsd"
        self.jobList.append(jb)
        ref = Database.database().reference()
        searchJobTableView.delegate = self
        searchJobTableView.dataSource = self
        readJobList();
    }
    
    func readJobList()
    {
        self.ref.child("jobs").observe(DataEventType.value) { (snapshot) in
            
            for child in snapshot.children
            {
                if let childSnapshot = child as? DataSnapshot{
                    let data1 = childSnapshot.value(forKey: "title")
                    let data2 = childSnapshot.value(forKey: "description")
                    print(data1)
                    
                }
                
            }
            self.searchJobTableView.reloadData();
//            if let actulajoblistDB = joblistDB{
//                for jobObj in actulajoblistDB{
//                    let jb = job()
//                    jb.title = jobObj.title
//                    jb.description = jobObj.description
//                    self.jobList.append(jb);
//                }
//                self.searchJobTableView.reloadData();
//            }
        }
    }
    
}
extension SearchJobsViewController : UITableViewDelegate{
    
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


