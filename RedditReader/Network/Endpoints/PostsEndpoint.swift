//
//  PostsEndpoint.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/10/24.
//

import Foundation

enum PostsEndpoint {
    case postRow(subreddit: String, limit: Int?, after: String?)
}

extension PostsEndpoint: Endpoint {
   
    
    var header: [String : String]? {
        nil
    }
    
    var path: String {
        switch self {
        case .postRow(let subreddit, _, _):
            return "/r/\(subreddit)/top.json"
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
        }
    }
    
    var type: RequestType {
        switch self {
        case .postRow:
            return .get
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .postRow:
            return nil
        }
    }
}
