//
//  MasterViewController.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/11/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    let channels = ["Engineering",
                    "Growth",
                    "Sales-BD",
                    "UX",
                    "Tradecraft"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // remove tableView separator lines
        self.tableView.tableFooterView = UIView()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetail" {
            
            var messageVC = segue.destinationViewController as DetailViewController

            if let indexPath = self.tableView.indexPathForSelectedRow() {
                // TODO: Hand off data to the DetailViewController
                messageVC.channel = channels[indexPath.row]
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.channels.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel!.text = channels[indexPath.row]
        
//        let rgbByRow = [
//            (4, 109, 139),
//            (48, 146, 146),
//            (47, 184, 172),
//            (147, 164, 42),
//            (236, 190, 19)
//        ]
//        
//        func colorForRow (row: Int) -> UIColor {
//            let rgbTuple = rgbByRow[row]
//            return UIColor (red: rgbTuple.0/255, green: rgbTuple.1/255, blue: rgbTuple.2/255, alpha: 1.0)
//        }
        
        let colorForCell = (
            darkBlue: UIColor(red: 4/255, green: 109/255, blue: 139/255, alpha: 1.0),
            darkTeal: UIColor(red: 48/255, green: 146/255, blue: 146/255, alpha: 1.0),
            lightTeal: UIColor(red: 47/255, green: 184/255, blue: 172/255, alpha: 1.0),
            green: UIColor(red: 147/255, green: 164/255, blue: 42/255, alpha: 1.0),
            orange: UIColor(red: 236/255, green: 190/255, blue: 19/255, alpha: 1.0)
        )
        
        if indexPath.row == 0 {
            cell.backgroundColor = colorForCell.darkBlue
        } else if indexPath.row == 1 {
            cell.backgroundColor = colorForCell.darkTeal
        } else if indexPath.row == 2 {
            cell.backgroundColor = colorForCell.lightTeal
        } else if indexPath.row == 3 {
            cell.backgroundColor = colorForCell.green
        } else if indexPath.row == 4 {
            cell.backgroundColor = colorForCell.orange
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let screenHeight: CGFloat = tableView.bounds.height
        
        var rowHeight: CGFloat = 0
        
        if channels.count > 4 && channels.count < 8 {
            rowHeight = (screenHeight - 64) / CGFloat(channels.count)
            tableView.rowHeight = rowHeight
        } else  {
            rowHeight = tableView.estimatedRowHeight
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 80.0
        }
        return rowHeight
        
    }
}

