//
//  AllPuzzlesRequest.swift
//  
//
//  Created by Niels van Hoorn on 2023-08-26.
//

import Foundation

struct AllPuzzlesRequest: Request {
    typealias Output = Puzzle

    var path = "puzzles"
}
