//
//  Post.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/9/24.
//

import Foundation


// MARK: - PostData
struct PostData: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let after: String?
    let children: [Child]

    enum CodingKeys: String, CodingKey {
        case after
        case children
    }
}

// MARK: - Child
struct Child: Codable {
    let data: Post
}

// MARK: - Post
struct Post: Codable {
    let subreddit: String
    let authorFullname: String?
    let title: String
    let downs: Int
    let ups: Int
    let created: Int
    let domain: String
    let preview: Preview?
    let numComments: Int
    var saved: Bool = Bool.random()

    enum CodingKeys: String, CodingKey {
        case subreddit
        case authorFullname = "author_fullname"
        case title
        case downs
        case ups = "ups"
        case created
        case domain
        case preview
        case numComments = "num_comments"
        case saved
    }
}

// MARK: - Preview
struct Preview: Codable {
    let images: [Image]
}

// MARK: - Image
struct Image: Codable {
    let source: Source
}

// MARK: - Source
struct Source: Codable {
    let url: String
}
