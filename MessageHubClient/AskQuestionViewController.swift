//
//  AskQuestionViewController.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/17/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class AskQuestionViewController: UIViewController {

    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var channel = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        submitButton.setTitle("Post to \(channel) Wall", forState: UIControlState.Normal)
        
        println("channel is \(channel)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func askQuestion(sender: AnyObject) {
        // TODO: post question to database and add to DetailVC
        
        
        
        postMessage()
        
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
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
