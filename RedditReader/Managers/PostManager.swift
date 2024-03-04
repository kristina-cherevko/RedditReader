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
    
    private init() {}
    
    // Save posts to a file
    func savePosts(_ posts: [Post]) {
        do {
            let data = try JSONEncoder().encode(posts)
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let postsUrl = documentsPath.appendingPathComponent(fileName)
            try data.write(to: postsUrl)
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
