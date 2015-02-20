//
//  Message.swift
//  MessageHubClient
//
//  Created by Donnie Wang on 2/13/15.
//  Copyright (c) 2015 Donnie Wang. All rights reserved.
//

import UIKit

class Message: NSObject {
    let channel : String
    let text : String
    
    init(channel: String, text : String) {
        self.channel = channel
        self.text = text
    }
}