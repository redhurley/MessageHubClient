//
//  DetailViewController.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/11/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, AskQuestionViewControllerDelegate {
    
    var messages = [
        Message(channel: "", text: ""),
    ]

    var channel = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
                
        getMessages()
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
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let message = self.messages[messages.count - (indexPath.row + 1)]
        cell.messageLabel.text = "\(message.text)"
        return cell
    }
    
    // TODO: delete message from 'messages' object
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            messages.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "askQuestion" {
            
            var questionVC = segue.destinationViewController as AskQuestionViewController
            
            // Hand off data to the AskQuestionViewController
            questionVC.channel = self.channel
            
            // set as delegate
            questionVC.delegate = self
        }
    }
    
    // MARK: - Networking
    
    func alertWithError(error : NSError) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.description,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func messagesFromNetworkResponseData(responseData : NSData) -> Array<Message>? {
        var serializationError : NSError?
        let messageAPIDictionaries = NSJSONSerialization.JSONObjectWithData(
            responseData,
            options: nil,
            error: &serializationError
            ) as Array<Dictionary<String, String>>
        
        if let serializationError = serializationError {
            alertWithError(serializationError)
            return nil
        }
        
        var messages = messageAPIDictionaries.map({ (messageAPIDictionary) -> Message in
            let channel = messageAPIDictionary["channel_token"]!
            let messageText = messageAPIDictionary["message_text"]!
            return Message(channel: channel, text: messageText)
        })
        
        return messages
    }
    
    func getMessages() {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest()
        request.HTTPMethod = "GET"
        request.URL = NSURL(string: "http://tradecraftmessagehub.com/sample/\(channel)")
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                if let error = error {
                    self.alertWithError(error)
                } else if let messages = self.messagesFromNetworkResponseData(data) {
                    self.messages = messages
                    self.tableView.reloadData()
                }
            }
        })
        
        task.resume()
    }
    
    func AskQuestionViewControllerDidCreateMessageText(channel: String, messageText: String) {
        // TODO: take string from AskQuestionVC textView and add it to end of messages array
        let newMessage = Message(channel: channel, text: messageText)
        self.messages.append(newMessage)
        // TODO: update tableView
        tableView.reloadData()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        
    }
}

