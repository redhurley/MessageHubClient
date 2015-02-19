//
//  AskQuestionViewController.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/17/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class AskQuestionViewController: UIViewController {
    
    var delegate : AskQuestionViewControllerDelegate?

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var channel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.questionTextField.becomeFirstResponder()

        // Do any additional setup after loading the view.
        
        submitButton.setTitle("Post to \(channel) Wall", forState: UIControlState.Normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func askQuestion(sender: AnyObject) {
        // TODO: post question to server and add to DetailVC
        postMessage()
        
    self.delegate?.AskQuestionViewControllerDidCreateMessageText(channel, messageText: self.questionTextField.text)
        self.dismissViewControllerAnimated(true, completion: nil)
    
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

    func postMessage() {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest()
        request.HTTPMethod = "POST"
        request.URL = NSURL(string: "http://tradecraftmessagehub.com/sample/\(channel)")
        
        var params = ["user_name":"", "message_text":"\(questionTextField.text)"] as Dictionary<String, String>
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println("Response: \(response)")
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("Body: \(strData)")
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success)")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    // Whoa, okay the json object was nil, something went wrong. Maybe the server isn't running?
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
    }
}

protocol AskQuestionViewControllerDelegate: NSObjectProtocol {
    
    func AskQuestionViewControllerDidCreateMessageText(channel: String, messageText: String)
}
