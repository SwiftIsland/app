//
//  Puzzle.swift
//  
//
//  Created by Niels van Hoorn on 2023-08-26.
//

import Foundation

public struct Puzzle: Response {
    public let slug: String
    public let order: Int
    public let number: String
    public let title: String
    public let filename: String
    public let question: String
    public let tip: String?
    public let answerLength: String
    public let encryptedHint: String
}

extension Puzzle: Identifiable, Hashable {
    public var id: String { number }
}

extension Puzzle {
    public static func forPreview(slug: String = "ABCDEF",
                                  order: Int = 0,
                                  number: String = "1",
                                  title: String = "Hard Puzzle",
                                  filename: String = "valuta.pdf",
                                  question: String = "What is the answer",
                                  tip: String? = "You should be smart",
                                  answerLength: String = "1,4",
                                  encryptedHint: String = "EncryptedData") -> Puzzle {
        Puzzle(
            slug: slug,
            order: order,
            number: number,
            title: title,
            filename: filename,
            question: question,
            tip: tip,
            answerLength: answerLength,
            encryptedHint: encryptedHint
        )
    }
}
