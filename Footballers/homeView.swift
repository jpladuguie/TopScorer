//
//  homeView.swift
//  Footballers
//
//  Created by Jean-Pierre Laduguie on 23/08/2016.
//  Copyright © 2016 Jean-Pierre Laduguie. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// The main home View Controller.
class homeView: templateViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Data variables.
    var topScorersData = [[String: String]]()
    var topAssistsData = [[String: String]]()
    var topDefenderData = [[String: String]]()
    var topPlayersData = [[String: String]]()
    
    // Image for the top passer.
    var topDefenderImage: UIImage!
    
    
    /* viewDidLoad() */
    
    // Called when the view loads.
    override func viewDidLoad() {
        
        // Set the view type.
        self.type = .Home
        
        // Call viewDidLoad() in parent view controller.
        super.viewDidLoad()
        
        // Set the title.
        self.title = "Home"
        
        // Get the data in the background, and once it has finished create all the sub views.
        getData()
    }
    
    /* Table view functions */
    
    // Set the number of rows in the table view.
    // 19 are needed:
    //  - Top Scorers title
    //  - 5 for the top scorers
    //  - Divider
    //  - Most Assists title
    //  - 3 for the most assists
    //  - Divider
    //  - Best Passer title
    //  - Best Passer cell
    //  - Divider
    //  - In Form Players title
    //  - 3 for in form players
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 19
    }
    
    // Set up tableView cells.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create cell.
        var cell:UITableViewCell?
        
        // Top Scorers title cell.
        if (indexPath as NSIndexPath).row == 0 {
            // Create a cell from the playerDividerCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
                
            title.titleLabel.text = "Top Scorers"
                
            // Set the main cell to the new one.
            cell = title
        }
        
        // Top Scorer cells.
        else if (indexPath as NSIndexPath).row > 0 && (indexPath as NSIndexPath).row < 6 {
            
            // Create the custom cell using the rankingTableCell class..
            let rankingCell: playerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerCell.self), for: indexPath) as! playerCell
            
            rankingCell.selectionStyle = .gray
            
            rankingCell.contentView.addSubview(rankingCell.positionLabel)
            
            // Flag image.
            
            rankingCell.contentView.addSubview(rankingCell.flagImage)
            
            // Name label.
            rankingCell.nameLabel.frame = CGRect(x: 95, y: 0, width: UIScreen.main.bounds.width - 115, height: 40)
            rankingCell.contentView.addSubview(rankingCell.nameLabel)
            
            // Stat value label.
            rankingCell.valueLabel.frame = CGRect(x: UIScreen.main.bounds.width - 70, y: 0, width: 50, height: 40)
            rankingCell.addSubview(rankingCell.valueLabel)
            
            // Move the everything slightly to the left, as the ranking numbers will only
            // Be between 1 and 5, so space for only one digit is needed and not 3 which
            // Is the default.
            rankingCell.positionLabel.frame = CGRect(x: 20, y: 0, width: 10, height: 40)
            rankingCell.flagImage.frame = CGRect(x: 40, y: 11.5, width: 23, height: 17)
            rankingCell.nameLabel.frame = CGRect(x: 75, y: 0, width: UIScreen.main.bounds.width - 95, height: 40)
            
            // Assign the correct values to the tableView cell.
            rankingCell.positionLabel.text = String(indexPath.row)
            rankingCell.nameLabel.text = self.topScorersData[(indexPath as NSIndexPath).row - 1]["Name"]
            rankingCell.valueLabel.text = self.topScorersData[(indexPath as NSIndexPath).row - 1]["Goals"]
            rankingCell.flagImage.image = UIImage(named: String((self.topScorersData[(indexPath as NSIndexPath).row - 1]["RegionCode"]?.uppercased())! + "")!)!
            
            // Set the cell.
            cell = rankingCell
        }
        
        // Most Assists title cell.
        else if (indexPath as NSIndexPath).row == 7 {
            // Create a cell from the playerDividerCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
                
            title.titleLabel.text = "Most Assists"
                
            // Set the main cell to the new one.
            cell = title
        }
            
        // Most Assist cells.
        else if (indexPath as NSIndexPath).row > 7 && (indexPath as NSIndexPath).row < 11 {
            // Create a cell from the playerRatingCell class.
            let ratingCell: playerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(playerCell.self), for: indexPath) as! playerCell
            
            // Set selection style.
            ratingCell.selectionStyle = .gray
            
            // Stat name label.
            ratingCell.nameLabel.frame = CGRect(x: 20, y: 0, width: ((UIScreen.main.bounds.width / 3) * 2), height: 35)
            ratingCell.contentView.addSubview(ratingCell.nameLabel)
            
            // Stat value label.
            ratingCell.valueLabel.frame = CGRect(x: ((UIScreen.main.bounds.width / 3) * 2), y: 0, width: (UIScreen.main.bounds.width / 3) - 20, height: 35)
            ratingCell.contentView.addSubview(ratingCell.valueLabel)
            
            // Add rating bar.
            ratingCell.contentView.addSubview(ratingCell.ratingBar)
                
            // Set the values of the rating name and its value.
            ratingCell.nameLabel.text = self.topAssistsData[(indexPath as NSIndexPath).row - 8]["Name"]
            ratingCell.valueLabel.text = self.topAssistsData[(indexPath as NSIndexPath).row - 8]["Assists"]
                
            // Get the rating value as a float.
            let ratingValue: Float = Float(self.topAssistsData[(indexPath as NSIndexPath).row - 8]["Assists"]!)! / Float(self.topAssistsData[0]["Assists"]!)! * 100.0
            // Get the bar width depending on the value and the screen width.
            let barWidth: Int = Int(Float(ratingValue * Float(self.view.frame.width - 40)) / 100.0)
            // Create the bar as a UIView and set its colour depending on the strength of the rating.
            ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: 0, height: 10)
            ratingCell.ratingBar.backgroundColor = getRatingColour(value: Int(ratingValue))
                
            // Animate the rating bar so that it slides in.
            UIView.animate(withDuration: 1.0, animations: {
                ratingCell.ratingBar.frame = CGRect(x: 20, y: 40, width: barWidth, height: 10)
            })
                
            // Set the main cell to the new one.
            cell = ratingCell
        }
        
        // Divider cell.
        else if (indexPath as NSIndexPath).row == 11 {
            // Create a cell from the playerDividerCell class.
            let divider: dividerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(dividerCell.self), for: indexPath) as! dividerCell
            
            divider.divider.frame = CGRect(x: 20.0, y: 32.5, width: UIScreen.main.bounds.width - 40, height: 0.5)
            
            // Set the main cell to the new one.
            cell = divider
        }
        
        // In Form Players title cell.
        else if (indexPath as NSIndexPath).row == 12 {
            // Create a cell from the playerDividerCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
            
            title.titleLabel.text = "Best Defender"
            
            // Set the main cell to the new one.
            cell = title
        }
        
        else if (indexPath as NSIndexPath).row == 13 {
            // Create cell.
            let rankingCell: imageRankingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(imageRankingCell.self), for: indexPath) as! imageRankingCell
            
            rankingCell.nameLabel.text = self.topDefenderData[0]["Name"]
            rankingCell.teamLabel.text = self.topDefenderData[0]["Team"]
            
            let image = UIImage(named: String((self.topDefenderData[0]["RegionCode"]?.uppercased())! + ""))
            
            rankingCell.flagImage.image = image
            rankingCell.playerImage.image = self.topDefenderImage
            
            cell = rankingCell
        }
            
        else if (indexPath as NSIndexPath).row == 15 {
            // Create a cell from the playerDividerCell class.
            let title: titleCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(titleCell.self), for: indexPath) as! titleCell
            
            title.titleLabel.text = "In Form Players"
            
            // Set the main cell to the new one.
            cell = title
        }
            
        // In Form player cells.
        else if (indexPath as NSIndexPath).row > 15 && (indexPath as NSIndexPath).row < 19 {
            // Create the cell as a rankingTableCell.
            let detailedCell: detailedRankingCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(detailedRankingCell.self), for: indexPath) as! detailedRankingCell
            
            // Set the values for the ranking position, flag image, player name, statistic value, age and team.
            detailedCell.positionLabel.text = String(indexPath.row - 15)
            detailedCell.flagImage.image = UIImage(named: String((self.topPlayersData[(indexPath as NSIndexPath).row - 16]["RegionCode"]?.uppercased())! + ""))
            detailedCell.nameLabel.text = self.topPlayersData[(indexPath as NSIndexPath).row - 16]["Name"]
            detailedCell.ageLabel.text = self.topPlayersData[(indexPath as NSIndexPath).row - 16]["Age"]
            detailedCell.teamLabel.text = self.topPlayersData[(indexPath as NSIndexPath).row - 16]["Team"]
            
            cell = detailedCell
        }
        
        // Otherwise any other cells should be divider cells.
        else {
            // Create a cell from the playerDividerCell class.
            let divider: dividerCell = tableView.dequeueReusableCell( withIdentifier: NSStringFromClass(dividerCell.self), for: indexPath) as! dividerCell
            
            // Set the main cell to the new one.
            cell = divider
        }
        
        // Return the cell.
        cell?.layer.anchorPointZ = CGFloat((indexPath as NSIndexPath).row)
        return cell!
    }
    
    // Set the row height for the table view cells depending on which cell they are.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Depending on which cell is being used vary the height.
        switch (indexPath as NSIndexPath).row {
        case 6:
            return 20.0
        case 8..<11:
            return 50.0
        case 11:
            return 45.0
        case 13:
            return 85.0
        case 14:
            return 20.0
        case 16..<19:
            return 85.0
        default:
            return 40.0
        }
        
    }
    
    // This is called when a row in the table view is selected, i.e. a player has been clicked on.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect the row.
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get the row of the cell which was selected.
        let row = (indexPath as NSIndexPath).row
        
        // Depending on which player was selected, open the correct player view.
        switch row {
        case 1..<6:
            self.selectedPlayerData = self.topScorersData[(indexPath as NSIndexPath).row - 1]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        case 8..<11:
            self.selectedPlayerData = self.topAssistsData[(indexPath as NSIndexPath).row - 8]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        case 13:
            self.selectedPlayerData = self.topDefenderData[0]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        case 16..<19:
            self.selectedPlayerData = self.topPlayersData[(indexPath as NSIndexPath).row - 16]
            performSegue(withIdentifier: "homePlayerSegue", sender: self)
        default: break
        }
        
    }
    
    // Called when a segue is about to be performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If a player has been selected, send the correct PlayerId to the playerView.
        if(segue.identifier == "homePlayerSegue") {
            let playerClass = (segue.destination as! playerView)
            playerClass.playerData = self.selectedPlayerData
        }
        // If a ranking has been selected, send the correct type of ranking to rankingsView.
        else if (segue.identifier == "homeRankingSegue") {
            //self.tabBarController?.selectedIndex = 1
            let rankingClass = (segue.destination as! rankingsView)
            rankingClass.rankingType = self.selectedRanking
        }
    }
    
    /* Data Functions */
    
    // Get the data.
    override func getData() {
        
        // Cancel any pending operations.
        self.queue.cancelAllOperations()
        
        // Define the operation.
        self.getDataOperation = BlockOperation()
        
        // Run in the background to prevent the UI from freezing.
        getDataOperation.addExecutionBlock {
            
            // Create the request.
            self.topScorersData = getPlayerRankings(SortValue: "Goals", StartPosition: 0, EndPosition: 5)
            self.topAssistsData = getPlayerRankings(SortValue: "Assists", StartPosition: 0, EndPosition: 3)
            self.topDefenderData = getPlayerRankings(SortValue: "DefendingRating", StartPosition: 0, EndPosition: 1)
            self.topPlayersData = getPlayerRankings(SortValue: "OverallRating", StartPosition: 0, EndPosition: 3)
            
            // Create a boolean which is true if the data is successfully received.
            var success: Bool!
            
            // If topScorersData is empty, then the data wasn't successfully received, so success should be set to false, and vice versa.
            if self.topScorersData.isEmpty == false {
                success = true
                // If the data has been successfully received, get any images needed.
                self.topDefenderImage = self.getImage(url: self.topDefenderData[0]["PhotoUrl"]!, type: .Player) }
            else {
                success = false }
            
            // Reload the table view and show the correct views.
            super.getData(success: success)
            
        }
        
        // Add the operation to the queue.
        self.queue.addOperation(self.getDataOperation)
    }
    
    /* createSubViews() */
    
    // Initiate all the subViews, and fade them in.
    override func createTableView() {
        
        // Create the table view.
        super.createTableView()
        
        // Set the delegate and data source.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Remove separators.
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Add table view cells.
        self.tableView.register(playerCell.self, forCellReuseIdentifier: NSStringFromClass(playerCell.self))
        self.tableView.register(imageRankingCell.self, forCellReuseIdentifier: NSStringFromClass(imageRankingCell.self))
        self.tableView.register(detailedRankingCell.self, forCellReuseIdentifier: NSStringFromClass(detailedRankingCell.self))
        self.tableView.register(titleCell.self, forCellReuseIdentifier: NSStringFromClass(titleCell.self))
        self.tableView.register(dividerCell.self, forCellReuseIdentifier: NSStringFromClass(dividerCell.self))
        
        // Add refresh control to table view.
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    /* Other Functions */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
