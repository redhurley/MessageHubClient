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


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if indexPath.row == 0 {
            cell.backgroundColor = UIColor(red: 125/255, green: 202/255, blue: 9/255, alpha: 1.0)
        } else if indexPath.row == 1 {
            cell.backgroundColor = UIColor(red: 19/255, green: 221/255, blue: 197/255, alpha: 1.0)
        } else if indexPath.row == 2 {
            cell.backgroundColor = UIColor(red: 29/255, green: 166/255, blue: 211/255, alpha: 1.0)
        } else if indexPath.row == 3 {
            cell.backgroundColor = UIColor(red: 15/255, green: 191/255, blue: 167/255, alpha: 1.0)
        } else if indexPath.row == 4 {
            cell.backgroundColor = UIColor(red: 0/255, green: 124/255, blue: 74/255, alpha: 1.0)
        }
        
        return cell
    }
}

