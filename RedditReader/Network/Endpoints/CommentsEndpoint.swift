//
//  CommentsEndpoint.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/4/24.
//

import Foundation

enum CommentsEndpoint {
    case moreComments(linkId: String, children: [String])
}


extension CommentsEndpoint: Endpoint {
    
    var header: [String : String]? {
        nil
    }
    
    var path: String {
        switch self {
        case .moreComments(_, _):
            return "/api/morechildren.json"
        }
    }

    var queryItems: [String: String?]? {
        switch self {
        case .moreComments(let linkId, let children):
            var params = [String: String?]()
            params["link_id"] = String(linkId)
            params["children"] = children.joined(separator: ",")
            return params
        }
    }
    
    var type: HTTPMethod {
        switch self {
        case .moreComments:
            return .get
        }
    }
    
    var body: [String: String]? {
        switch self {
        case .moreComments:
            return nil
        }
    }
}
