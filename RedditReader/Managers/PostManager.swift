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
            print("data in savePosts: \(data)")
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            print("documents path \(documentsPath)")
            let postsUrl = documentsPath.appendingPathComponent(fileName)
            try data.write(to: postsUrl)
//            print("finished saving posts: \(posts)")
        } catch {
            print("Error saving posts: \(error)")
        }
    }
    
    // Load posts from a file
    func loadPosts() -> [Post] {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            print("documents path \(documentsPath)")
            let postsUrl = documentsPath.appendingPathComponent(fileName)

          if FileManager.default.fileExists(atPath: postsUrl.path) {
              let data = try Data(contentsOf: postsUrl)
              let posts = try JSONDecoder().decode([Post].self, from: data)
              print("finished loading \(posts) posts from file storage")
              return posts
          } else {
              let emptyPosts: [Post] = []
              let data = try JSONEncoder().encode(emptyPosts)
              try data.write(to: postsUrl)
              print("Posts file created successfully.")
              return emptyPosts
          }
        } catch {
            print("Error loading posts: \(error)")
            return []
        }
    }
}
