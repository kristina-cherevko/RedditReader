//
//  PostsService.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/10/24.
//

import Foundation

protocol PostsServiceable {
    func getPostDetail(subreddit: String, limit: Int, after: String?) async -> Result<PostData, RequestError>
}

struct PostsService: HTTPClient, PostsServiceable {
    func getPostDetail(subreddit: String, limit: Int, after: String?) async -> Result<PostData, RequestError> {
        return await sendRequest(endpoint: PostsEndpoint.postRow(subreddit: subreddit, limit: limit, after: after), responseModel: PostData.self)
    }
}
