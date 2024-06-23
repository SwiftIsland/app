//
//  File.swift
//  
//
//  Created by Paul Peelen on 2024-06-23.
//

import Foundation

struct AllMessagesRequest: Request {
    typealias Output = Message

    var path = "messages"
}
