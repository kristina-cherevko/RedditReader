//
//  Post.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/9/24.
//

import Foundation

//struct Post: Codable {
//    var kind: String
//    var data: String
//    var author_fullname: String
//    var created: Date
//    var domain: String
//    var title: String
//    var ups: Int
//    var downs: Int
//    var num_comments: Int
//    var saved: Bool = false
//    var images: String
//}

// MARK: - Post
struct PostData: Codable {
    let kind: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let after: String
    let children: [Child]

    enum CodingKeys: String, CodingKey {
        case after
        case children
    }
}

// MARK: - Child
struct Child: Codable {
    let kind: String
    let data: Post
}

// MARK: - ChildData
struct Post: Codable {
    let authorFullname: String
    let title: String
    let downs: Int
    let ups: Int
    let created: Int
    let domain: String
    let preview: Preview?
    let numComments: Int
    var saved: Bool = Bool.random()

    enum CodingKeys: String, CodingKey {
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
