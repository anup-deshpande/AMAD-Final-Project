//
//  searchJobsViewController.swift
//  Final5280
//
//  Created by Anup Deshpande on 11/27/19.
//  Copyright © 2019 Anup Deshpande. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    let transition = SlideInTransition()
    var topView: UIView?
    @IBOutlet weak var addJobButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let menuType = MenuType.searchJobs
        addJobButton.isEnabled = false
        addJobButton.tintColor = UIColor.clear
        self.transitionToNew(menuType)
        
    }
    
    @IBAction func didTapMenu(_ sender: UIBarButtonItem) {
        
        guard let menuViewController = storyboard?.instantiateViewController(identifier: "menuViewController") as? menuViewController else {return}
        
        menuViewController.didTapMenuType = { menuType in
            print(menuType)
            self.transitionToNew(menuType)
        }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        present(menuViewController, animated: true)
        
    }
    
    func transitionToNew(_ menuType: MenuType){
        topView?.removeFromSuperview()
        
        addJobButton.isEnabled = false
        addJobButton.tintColor = UIColor.clear
        
        switch menuType {
        case .logout:
            guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginNavigation") else { return }
            loginVC.modalPresentationStyle = .overCurrentContext
            do{
               try Auth.auth().signOut()
            }catch{
                
            }
            
            present(loginVC, animated: true)
            break
        
            
        case .jobPostings:
            self.title = "Job Postings"
            self.addJobButton.isEnabled = true
            self.addJobButton.tintColor = UIColor.black
            guard let yourJobPostingsVC = self.storyboard?.instantiateViewController(withIdentifier: "YourJobPostingsViewController") else { return }
            view.addSubview(yourJobPostingsVC.view)
            self.topView = yourJobPostingsVC.view
            addChild(yourJobPostingsVC)
            break
        
        case .searchJobs:
            self.title = "Search Jobs"
            guard let searchJobVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchJobsViewController") else { return }
            view.addSubview(searchJobVC.view)
            self.topView = searchJobVC.view
            addChild(searchJobVC)
            break
            
        case .ongoingJobs:
            
            self.title = "Ongoing Jobs"
            guard let ongoingJobVC = self.storyboard?.instantiateViewController(withIdentifier: "OngoingJobsViewController") else { return }
                       view.addSubview(ongoingJobVC.view)
                       self.topView = ongoingJobVC.view
                       addChild(ongoingJobVC)
            
            break
        }
        
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
        
    }
}

