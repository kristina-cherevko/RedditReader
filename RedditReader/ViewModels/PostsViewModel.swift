//
//  PostService.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/24/24.
//

import Foundation

class PostsViewModel {
    let postsService = PostsService()
    let postDataManager = PostDataManager.shared
    
    var onPostsUpdated: (()->Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    
    var isLoading: Bool = true 
//    {
//        didSet {
//            onLoadingStateChanged?(isLoading)
//        }
//    }
    var isFirstRequest = true
    var subreddit: String
    var after: String?
    private var posts: [Post] = [] {
        didSet {
            print("posts.count = \(posts.count)")
            self.onPostsUpdated?()
        }
    }
    
    init(subreddit: String, limit: Int, after: String?) {
        self.subreddit = subreddit
        self.isFirstRequest = false
        self.loadInitialPosts(subreddit: subreddit, limit: limit, after: after)
//        self.loadPosts(subreddit: subreddit, limit: limit, after: after)
    }
    
    
    func savePost(_ post: Post) {
        print("saving post \(post)")
        var savedPosts = postDataManager.loadPosts()
        savedPosts.append(post)
        postDataManager.savePosts(savedPosts)
        print("saved posts \(savedPosts)")
        
        if let index = self.posts.firstIndex(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created }) {
            self.posts[index] = post
            print("saved posts length: \(postDataManager.loadPosts().count) \n\n new post in save \(post)\n\n my post in posts \(self.posts[index]) \n\n\n")
        }
    }
    
    func savePosts(_ posts: [Post]) {
        var savedPosts = postDataManager.loadPosts()
        savedPosts.append(contentsOf: posts)
        postDataManager.savePosts(savedPosts)
        for post in posts {
            if let index = self.posts.firstIndex(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created }) {
                self.posts[index] = post
                print("saved posts length: \(postDataManager.loadPosts().count)  \n\n new post in unsave \(post)\n\n my post in posts \(self.posts[index]) \n\n\n")
            }
        }
    }
    
    func unsavePost(_ post: Post) {
        var savedPosts = postDataManager.loadPosts()
        savedPosts.removeAll(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created })
        postDataManager.savePosts(savedPosts)
        if let index = self.posts.firstIndex(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created }) {
               
            self.posts[index] = post
            print("saved posts length: \(postDataManager.loadPosts().count)  \n\n new post \(post)\n\n\n my post in posts \(self.posts[index]) \n\n\n")
        }
        
        print("hello in unsavePost")
    }
    
    func isPostSaved(_ post: Post) -> Bool {
        let savedPosts = postDataManager.loadPosts()
        return savedPosts.contains(where: { $0.title == post.title && $0.authorFullname == post.authorFullname && $0.created == post.created })
    }
    
    private func loadInitialPosts(subreddit: String, limit: Int, after: String?) {
        let savedPosts = postDataManager.loadPosts()
        self.posts = savedPosts
//        print(savedPosts[0].saved)
        loadPosts(subreddit: subreddit, limit: limit, after: after)
    }
    
    func loadPosts(subreddit: String, limit: Int, after: String?) {
        self.isLoading = true
        print("Loading posts...\(isLoading)")
        Task {
            let result = await postsService.getPostDetail(subreddit: subreddit, limit: limit, after: after)
            switch result {
            case .success(let postData):
                self.after = postData.data.after
                handleLoadedPosts(postData.data.children.map{ $0.data })
//                print(postData.data.children.count)
                
//                let savedPosts = self.postDataManager.loadPosts()
//                self.posts.append(contentsOf: postData.data.children.map{ $0.data })
//                mergePosts(with: savedPosts)
//                print(self.posts)
                self.isLoading = false
                //                let mergedPosts = self.mergePosts(postData.data.children.map{ $0.data }, with: savedPosts)
                print("Finished loading posts...\(isLoading)")
            case .failure(let error):
                print("Failed to fetch post detail: \(error)")
            }
        }
    }
    
    private func handleLoadedPosts(_ newPosts: [Post]) {
//        let savedPosts = postDataManager.loadPosts()
        var mergedPosts = self.posts
        for newPost in newPosts {
           if !posts.contains(where: { $0.title == newPost.title && $0.authorFullname == newPost.authorFullname && $0.created == newPost.created }) {
               mergedPosts.append(newPost)
           }
        }
        self.posts = mergedPosts
    }
    
    private func mergePosts(with savedPosts: [Post]) {
//        var mergedPosts = self.posts
        for savedPost in savedPosts {
            if let index = posts.firstIndex(where: {$0.title == savedPost.title && $0.authorFullname == savedPost.authorFullname && $0.created == savedPost.created }) {
//                print(mergedPosts[index])
                self.posts[index].saved = true
            } else {
//                print(savedPost)
                self.posts.append(savedPost)
            }
        }

    }
    
    func getPosts() -> [Post] {
        return posts
    }
}
