//
//  Comment.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/4/24.
//

import Foundation

struct CommentsData: Codable {
    let kind: String
    let data: DataClassComment
}

// MARK: - DataClass
struct DataClassComment: Codable {
    let children: [PurpleChild]

    enum CodingKeys: String, CodingKey {
        case children
    }
}

// MARK: - PurpleChild
struct PurpleChild: Codable {
    let kind: String
    let data: PurpleData
}

// MARK: - PurpleData
struct PurpleData: Codable {
    let downs: Int?
    let name: String
    let ups: Int?
    let authorFullname: String?
    let permalink: String?
    let created_utc: Int?
    let parentId: String?
    let body: String?
    let author: String?
    let children: [String]?

    enum CodingKeys: String, CodingKey {
        case downs
        case name
        case ups
        case authorFullname = "author_fullname"
        case permalink
        case created_utc = "created_utc"
        case parentId = "parent_id"
        case body
        case author
        case children
    }
}

// MARK: - Comment
struct Comment: Codable, Hashable {
    var id = UUID()
    var name: String
    var rating: Int
    var authorFullname: String
    var created_utc: Int
    var body: String
    var url: String
    var author: String
    
    init?(from child: PurpleChild) {
        let childData = child.data
        self.name = childData.name
        guard let body = childData.body else {
            return nil
        }
        self.rating = childData.ups! + childData.downs!
        self.authorFullname = childData.authorFullname ?? "deleted"
        self.created_utc = childData.created_utc!
        self.body = body
        self.url = childData.permalink!
        self.author = childData.author!
    }
    
    static func getTimeAgo(from rawSeconds: Int) -> String {
        let postingDate = Date(timeIntervalSince1970: TimeInterval(rawSeconds))
        let currentDate = Date()

        let timeDifference = currentDate.timeIntervalSince(postingDate)
        let days = Int(timeDifference / (24 * 3600))
        let hours = Int((timeDifference.truncatingRemainder(dividingBy: (24 * 3600))) / 3600)
        let minutes = Int((timeDifference.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(timeDifference.truncatingRemainder(dividingBy: 60))
        
        if days >= 365 {
            let years = Int(ceil(Double(days) / 365))
            return "\(years)y ago"
        } else if days >= 30 {
            let months = days / 30
            return "\(months)mo. ago"
        } else if days > 0 {
            return "\(days)d ago"
        } else if hours > 0 {
            return "\(hours)hr. ago"
        } else if minutes > 0 {
            return "\(minutes)min. ago"
        } else {
            return "\(seconds)sec. ago"
        }
    }
}
