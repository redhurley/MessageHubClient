//
//  DetailViewController.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/11/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    var messages = [
        Message(text: "hello world!", userName: "donnie"),
        Message(text: "hi this is a really long string that will likely go on two lines as long as I can get Xcode to respond properly by setting proper constraints.", userName: "nicki"),
        Message(text: "i rule", userName: "george"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as MessageTableViewCell
        
        let message = self.messages[indexPath.row]
        cell.messageLabel.text = "<\(message.userName)> \(message.text)"
        return cell
    }
    
    // TODO: delete message from 'messages' object
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            messages.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }

}

