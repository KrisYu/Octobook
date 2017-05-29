//
//  Book.swift
//  Octobook
//
//  Created by Xue Yu on 5/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Foundation

class Book{
    var title: String
    var summary: String
    var starCount: String
    var id: String
    var author: String
    var epubUrl: String
    
    
    init(aTitle: String, aSummary: String, aStarCount: String, anId: String, anAuthor: String, anEpubUrl: String){
        self.title = aTitle
        self.summary = aSummary
        self.starCount = aStarCount
        self.id = anId
        self.author = anAuthor
        self.epubUrl = anEpubUrl
    }
}
