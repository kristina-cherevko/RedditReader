//
//  PostsEndpoint.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/10/24.
//

import Foundation

enum SubredditEndpoint {
    case postRow(subreddit: String, limit: Int?, after: String?)
    case postComments(subreddit: String, postId: String, limit: Int?)
}

extension SubredditEndpoint: Endpoint {
    
    var header: [String : String]? {
        nil
    }
    
    var path: String {
        switch self {
        case .postRow(let subreddit, _, _):
            return "/r/\(subreddit)/top.json"
        case .postComments(let subreddit, let postId, _):
            return "/r/\(subreddit)/comments/\(postId)/.json"
        }
    }

    var queryItems: [String: String?]? {
        switch self {
        case .postRow(_, let limit, let after):
            var params = [String: String?]()
            if let limit = limit {
                params["limit"] = String(limit)
            }
            if let after = after {
                params["after"] = String(after)
            }
            
            return params
        case .postComments(subreddit: _,  _, let limit):
            var params = [String: String?]()
            if let limit = limit {
                params["limit"] = String(limit)
            }
            return params
        }
    }
    
    var type: HTTPMethod {
        switch self {
        case .postRow, .postComments:
            return .get
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .postRow, .postComments:
            return nil
        }
    }
}
