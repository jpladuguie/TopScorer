//
//  ViewControllerFunctions.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 23/10/2016.
//  Copyright © 2016 jp. All rights reserved.
//

import Foundation
import Kanna
import SwiftyJSON
import CoreData
import NVActivityIndicatorView

// Global colour variables.
let lightGrey: UIColor = UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0, alpha: 1.0)
let darkGrey: UIColor = UIColor(red: 55.0/255.0, green: 55.0/255.0, blue: 55.0/255.0, alpha: 1.0)

// Global View Controller variable to keep track of current View Controller.
var currentPage: String = String()

// Sets up the View Controller by setting the background colour, adding a menu button and
// Setting the navigation bar colour.
func setUpView(viewController: UIViewController) {
    
    // Set background.
    viewController.view.backgroundColor = lightGrey
    
    // Set the menu bar button image.
    let menuButton = UIButton(type: UIButtonType.custom) as UIButton
    menuButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    menuButton.setImage(UIImage(named: "menuButton.png"), for: UIControlState())
    
    // Set the function to be called depending on what the current View Controller is.
    let viewName = NSStringFromClass(viewController.classForCoder)
    switch viewName {
        case "Footballers.homeView":
            menuButton.addTarget(viewController, action: #selector(homeView.menuOpened(_:)), for:.touchUpInside)
        case "Footballers.teamsView":
            menuButton.addTarget(viewController, action: #selector(teamsView.menuOpened(_:)), for:.touchUpInside)
        case "Footballers.rankingsView":
            menuButton.addTarget(viewController, action: #selector(rankingsView.menuOpened(_:)), for:.touchUpInside)
        case "Footballers.compareView":
            menuButton.addTarget(viewController, action: #selector(compareView.menuOpened(_:)), for:.touchUpInside)
        case "Footballers.favouritesView":
            menuButton.addTarget(viewController, action: #selector(favouritesView.menuOpened(_:)), for:.touchUpInside)
        default:
            print("Error: incorrect View Controller class.")
    }
    
    // Add the menu button to the Navigation Controller.
    let leftBarButton = UIBarButtonItem()
    leftBarButton.customView = menuButton
    viewController.navigationItem.leftBarButtonItem = leftBarButton
    
    // Set the navigation bar colour
    viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    viewController.navigationController?.navigationBar.shadowImage = UIImage()
    let navBar = UIView()
    navBar.frame = CGRect(x: -1, y: 0, width: viewController.view.frame.width + 1, height: 64)
    navBar.backgroundColor = darkGrey
    viewController.view.addSubview(navBar)
    
    // Add a shadow effect to the bottom of the navigation bar.
    navBar.layer.shadowRadius = 1
    navBar.layer.shadowOpacity = 1
    navBar.layer.shadowColor = UIColor.black.cgColor
    navBar.layer.shadowOffset = CGSize.zero
    navBar.layer.shouldRasterize = true
    navBar.layer.shadowPath = UIBezierPath(rect: navBar.bounds).cgPath
}

// Create ActivityIndicator centred in the middle of the view and return it.
func configureActivityIndicator(viewController: UIViewController) -> NVActivityIndicatorView {
    let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: (viewController.view.frame.size.width/2 - 25), y: (viewController.view.frame.size.height/2 - 25), width: 50, height: 50), type: NVActivityIndicatorType.ballClipRotatePulse, color: UIColor.white)
    activityIndicator.startAnimating()
    
    return activityIndicator
}

