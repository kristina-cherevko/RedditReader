//
//  PostService.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/24/24.
//

import Foundation

class PostsViewModel {
    let postsService = SubredditService()
    let postDataManager = PostDataManager.shared
    
    var onPostsUpdated: (()->Void)?
    
    var isLoading: Bool = true
    var isFirstRequest = true
    var subreddit: String
    var after: String?
    var searchText: String?
    var inSearchMode = false {
        didSet {
            updateDisplayedPosts()
        }
    }
    var allPosts: [Post] = [] {
        didSet {
            updateDisplayedPosts()
        }
    }
    
    var displayedPosts: [Post] = [] {
        didSet {
            self.onPostsUpdated?()
        }
    }
    
    init(subreddit: String, limit: Int, after: String?) {
        self.subreddit = subreddit
        self.isFirstRequest = false
        self.loadInitialPosts(subreddit: subreddit, limit: limit, after: after)
    }
    
    func savePost(_ post: Post) {
//        var savedPosts = postDataManager.loadPosts()
//        savedPosts.append(post)
        postDataManager.savePost(post)
        
        if let index = self.allPosts.firstIndex(where: { $0.id == post.id }) {
            self.allPosts[index] = post
        }
    }
    
//    func savePosts(_ posts: [Post]) {
//        var savedPosts = postDataManager.loadPosts()
//        savedPosts.append(contentsOf: posts)
//        postDataManager.savePosts(savedPosts)
//        for post in posts {
//            
//            if let index = self.allPosts.firstIndex(where: { $0.id == post.id }) {
//                self.allPosts[index] = post
//            }
//        }
//    }
    
    func unsavePost(_ post: Post) {
//        var savedPosts = postDataManager.loadPosts()
//        savedPosts.removeAll(where: { $0.id == post.id })
        postDataManager.unsavePost(post)
        if let index = self.allPosts.firstIndex(where: { $0.id == post.id }) {
            self.allPosts[index] = post
        }
    }
    
    func isPostSaved(_ post: Post) -> Bool {
        let savedPosts = postDataManager.getPosts()
        return savedPosts.contains(where: { $0.id == post.id })
    }
    
    private func loadInitialPosts(subreddit: String, limit: Int, after: String?) {
        let savedPosts = postDataManager.getPosts()
        self.allPosts = savedPosts
        self.displayedPosts = savedPosts
        loadPosts(subreddit: subreddit, limit: limit, after: after)
    }
    
    func loadPosts(subreddit: String, limit: Int, after: String?) {
        self.isLoading = true
        Task {
            let result = await postsService.getPostDetail(subreddit: subreddit, limit: limit, after: after)
            switch result {
            case .success(let postData):
                self.after = postData.data.after
                handleLoadedPosts(postData.data.children.map{ $0.data })
                self.isLoading = false
            case .failure(let error):
                print("Failed to fetch post detail: \(error)")
            }
        }
    }
    
    private func handleLoadedPosts(_ newPosts: [Post]) {
        var mergedPosts = self.allPosts
        for newPost in newPosts {
           if !allPosts.contains(where: { $0.id == newPost.id }) {
               mergedPosts.append(newPost)
           }
        }
        self.allPosts = mergedPosts
    }
    
    func updateDisplayedPosts() {
        if inSearchMode {
            if let searchText = self.searchText, !searchText.isEmpty {
                displayedPosts = allPosts.filter { $0.saved && $0.title.lowercased().contains(searchText) }
            } else {
                displayedPosts = allPosts.filter { $0.saved }
            }
        } else {
            self.displayedPosts = allPosts
        }
    }
}


extension PostsViewModel {
    
    public func inSearchMode(isSearchBarShown: Bool, searchText: String?) -> Bool {
        let isActive = isSearchBarShown
        let searchText = searchText ?? ""
        return isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.searchText = searchBarText?.lowercased()
        updateDisplayedPosts()
    }
}




