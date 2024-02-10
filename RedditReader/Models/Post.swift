//
//  Post.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/9/24.
//

import Foundation

struct Post {
    var username: String
    var createdAt: Date
    var domain: String
    var title: String
    var rating: Int
    var commentsCount: Int
    var saved: Bool = false
    var image: String
}
