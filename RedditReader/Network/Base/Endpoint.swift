//
//  Endpoint.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/10/24.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var type: RequestType { get }
    var header: [String: String]? { get }
    var body: [String: String]? { get }
    var queryItems: [String: String?]? { get }
}

extension Endpoint {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "www.reddit.com"
    }
}

