//
//  PostListViewModel.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/24/24.
//

import Foundation

//class PostsViewModel {
//    private let repository = PostRepository.shared
//    
//    // Спостережувана властивість для списку постів
//    @Published var posts: [Post] = []
//    
//    // Метод для завантаження постів
//    func loadPosts() {
//        posts = repository.loadPosts()
//    }
//    
//    // Метод для збереження поста
//    func savePost(_ post: Post) {
//        repository.savePost(post)
//        loadPosts() // Оновлюємо список постів після збереження
//    }
//    
//    // Метод для видалення поста
//    func unsavePost(_ post: Post) {
//        repository.unsavePost(post)
//        loadPosts() // Оновлюємо список постів після видалення
//    }
//    
//    // Перевірка, чи пост збережений
//    func isPostSaved(_ post: Post) -> Bool {
//        return repository.isPostSaved(post)
//    }
//}
