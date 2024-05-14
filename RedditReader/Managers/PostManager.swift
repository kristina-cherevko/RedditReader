//
//  PostManager.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/22/24.
//

import Foundation

class PostDataManager {
    static let shared = PostDataManager()
    private let fileName = "posts.json"
        private var savedPosts: [Post] = []
        
    private init() {
        savedPosts = loadPosts()
    }
    
    func savePostsIfNeeded() {
        savePostsToFile()
    }
    
    func loadPostsIfNeeded() {
        savedPosts = loadPosts()
    }
    
    func getAllSavedPosts() -> [Post] {
        return savedPosts
    }
    
    func savePost(_ post: Post) {
        if !savedPosts.contains(where: { $0.id == post.id }) {
            savedPosts.append(post)
        }
    }
    
    func unsavePost(_ post: Post) {
        savedPosts.removeAll { $0.id == post.id }
    }
    
    func getPosts() -> [Post] {
        return savedPosts
    }
    
    // Save posts to a file
    func savePostsToFile() {
        do {
            let data = try JSONEncoder().encode(savedPosts)
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let postsUrl = documentsPath.appendingPathComponent(fileName)
            try data.write(to: postsUrl, options: .atomic)
        } catch {
            print("Error saving posts: \(error)")
        }
    }
    
    // Load posts from a file
    func loadPosts() -> [Post] {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let postsUrl = documentsPath.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: postsUrl.path) {
                let data = try Data(contentsOf: postsUrl)
                let posts = try JSONDecoder().decode([Post].self, from: data)
                return posts
            } else {
                let emptyPosts: [Post] = []
                let data = try JSONEncoder().encode(emptyPosts)
                try data.write(to: postsUrl)
                return emptyPosts
            }
        } catch {
            print("Error loading posts: \(error)")
            return []
        }
    }
}
