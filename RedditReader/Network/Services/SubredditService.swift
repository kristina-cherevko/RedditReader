//
//  PostsService.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/10/24.
//

import Foundation

//protocol PostsServiceable {
//    func getPostDetail(subreddit: String, limit: Int, after: String?) async -> Result<PostData, RequestError>
//}

struct SubredditService: NetworkHandler {
    func getPostDetail(subreddit: String, limit: Int, after: String?) async -> Result<PostData, RequestError> {
        return await sendRequest(endpoint: SubredditEndpoint.postRow(subreddit: subreddit, limit: limit, after: after), responseModel: PostData.self)
    }
    
    func getComments(subreddit: String, postId: String, limit: Int) async -> Result<[CommentsData], RequestError> {
        return await sendRequest(endpoint: SubredditEndpoint.postComments(subreddit: subreddit, postId: postId, limit: limit), responseModel: [CommentsData].self)
    }
    
    func getMoreComments(linkId: String, children: [String]) async -> Result<MoreCommentsData, RequestError> {
        return await sendRequest(endpoint: CommentsEndpoint.moreComments(linkId: linkId, children: children), responseModel: MoreCommentsData.self)
    }
}
