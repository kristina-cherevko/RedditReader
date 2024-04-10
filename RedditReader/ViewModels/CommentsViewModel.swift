//
//  CommentsViewModel.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/4/24.
//

import Foundation

class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    let subreddit: String
    let postId: String
    let limit = 10
    let networkHandler = SubredditService()
    var linkId: String?
    var leftComments: [String] = []
    var isMoreDataAvailable: Bool {
        !leftComments.isEmpty
    }
    var isLoading: Bool {
        viewState == .loading
    }
    var isFetching: Bool {
        viewState == .fetching
    }
    @Published private(set) var viewState: ViewState?
    
    enum ViewState {
        case loading
        case fetching
        case finished
    }
    init(subreddit: String, postId: String) {
        self.subreddit = subreddit
        self.postId = postId
        fetchComments()
    }
    
    func fetchComments() {
        if self.viewState != .loading && self.viewState != .fetching {
            self.viewState = .loading
            Task {
                let result = await networkHandler.getComments(subreddit: subreddit, postId: postId, limit: limit)
                switch result {
                case .success(let commentsData):
                    let transformedComments = transformComments(commentsData)
                    DispatchQueue.main.async {
                        self.comments = transformedComments
                        self.viewState = .finished
                    }
//                    print("comments count: \(self.comments.count)")
                case .failure(let error):
                    // Handle error
                    print("Failed to fetch comments: \(error)")
                }
            }
        }
    }
    
    private func transformComments(_ commentsData: [CommentsData]) -> [Comment] {
        var transformedComments: [Comment] = []
        for commentData in commentsData {
            for child in commentData.data.children {
                if child.kind == "more" {
                    self.leftComments = child.data.children ?? []
                    self.linkId = child.data.parentId
                } else {
                    if let comment = Comment(from: child) {
                        transformedComments.append(comment)
                    }
                }
            }
        }
        return transformedComments
    }
    
    
    func loadMoreData() {
        guard self.viewState != .fetching && !leftComments.isEmpty else {
            return
        }
        self.viewState = .fetching
        Task {
            guard let linkId = linkId else {
                return
            }
            let extractedNicknames = Array(self.leftComments.prefix(min(self.leftComments.count, limit)))
            self.leftComments.removeFirst(min(self.leftComments.count, limit))
            let result = await networkHandler.getMoreComments(linkId: linkId, children: extractedNicknames)
            switch result {
            case .success(let moreCommentsData):
                let moreComments = transformMoreComments(moreCommentsData)
                DispatchQueue.main.async {
                    self.comments.append(contentsOf: moreComments)
                    self.viewState = .finished
                }
            case .failure(let error):
                // Handle error
                print("Failed to fetch comments: \(error)")
            }
        }
    }
    
    func transformMoreComments(_ moreComentsData: MoreCommentsData) -> [Comment] {
        var transformedComments: [Comment] = []
        for array in moreComentsData.jquery {
            for case let .unionArray(jqueryJqueryUnionArray) in array {
                for case let .jqueryClassArray(jqueryClassArray) in jqueryJqueryUnionArray {
                    for child in jqueryClassArray {
                        if let comment = Comment(from: child) {
                            transformedComments.append(comment)
                        }
                    }
                }
            }
        }
        return transformedComments
    }
    
    func hasReachedEnd(of comment: Comment) -> Bool {
        comments.last?.id == comment.id
    }
}
