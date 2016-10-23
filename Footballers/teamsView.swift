//
//  teamsView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 01/09/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import UIKit

class teamsView: UIViewController {
    
    // Called when menu button is pressed.
    @IBAction func menuOpened(_ sender: AnyObject) {
        performSegue(withIdentifier: "teamsMenuSegue", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the current page and title.
        currentPage = "Teams"
        self.title = "Teams"
        
        // Set up the View Controller.
        setUpView(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
