//
//  DetailViewController.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/11/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, AskQuestionViewControllerDelegate {
    
    var messages : [Message]?

    var channel = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove tableView separator lines
        self.tableView.tableFooterView = UIView()
        
        // This function does everything necessary to get messages from the server and update both our models and our views when they arrive.
        getMessages()
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.messages?.count {
            return count
        } else {
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as MessageTableViewCell
                
        let message = self.messages![messages!.count - (indexPath.row + 1)]
        cell.messageLabel.text = message.text
        return cell
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
        // Post-iOS7, network requests are issued within the context of a NSURLSession. Check the docs to see all the things it can do :) We'll just ask for a standard universal instance.
        let session = NSURLSession.sharedSession()
        
        // We have to construct our URL request. This is similar to what we might do in a tool like Postman.
        let request = NSMutableURLRequest()
        request.HTTPMethod = "GET"
        request.URL = NSURL(string: "http://tradecraftmessagehub.com/sample/\(channel)")
        
        // We're defining a data retrieval task that's meant to send out the request we've crafted. As an additional parameter, we give it a closure to execute when the data comes back (or when the request fails.)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
                
                // There might have been an error...
                if let error = error {
                    self.alertWithError(error)
                    
                // But if there wasn't, use the function we're about to define a few lines below to spin up an array of Messages using the response data...
                } else if let messages = self.messagesFromNetworkResponseData(data) {
                    
                    // We have new messages! Update our model!
                    self.messages = messages
                    
                    // ...And with our model updated, tell our view to update too! (It'll send all those UITableViewDataSource questions back at us again.)
                    self.tableView.reloadData()
                }
            }
        })
        // And since we've only defined the task and not sent it, as the final step, let's send it now. (By... resuming it for the first time.)
        task.resume()
    }
    
    func askQuestionViewControllerDidCreateMessageText(channel: String, messageText: String) {
        
        // take string from AskQuestionVC textView and add it to end of messages array
        let newMessage = Message(channel: channel, text: messageText)
        self.messages!.append(newMessage)
        
        // update tableView
        tableView.reloadData()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        
    }
}

