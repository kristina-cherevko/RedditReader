//
//  PostService.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/24/24.
//

import Foundation

class PostRepository {
    static let shared = PostRepository()
    let postsService = PostsService()
    let postDataManager = PostDataManager.shared
    
    private init() {}
    
    func savePost(_ post: Post) {
        var savedPosts = postDataManager.loadPosts()
        if !savedPosts.contains(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created }) {
            savedPosts.append(post)
            postDataManager.savePosts(savedPosts)
        }
    }
    
    func unsavePost(_ post: Post) {
        var savedPosts = postDataManager.loadPosts()
        savedPosts.removeAll(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created })
        postDataManager.savePosts(savedPosts)
    }
    
    func isPostSaved(_ post: Post) -> Bool {
        let savedPosts = postDataManager.loadPosts()
        return savedPosts.contains(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created })
    }
}
