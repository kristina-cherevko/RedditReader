//
//  CommentsView.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/4/24.
//

import SwiftUI

struct CommentsView: View {
    @ObservedObject var viewModel: CommentsViewModel
    var didSelectComment: ((Comment) -> Void)?
    
    init(viewModel: CommentsViewModel, didSelectComment: ((Comment) -> Void)?) {
        self.viewModel = viewModel
        self.didSelectComment = didSelectComment
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.comments, id: \.id) { comment in
                    CommentCell(comment: comment)
                        .onTapGesture {
                            didSelectComment?(comment) // Notify the closure when a comment is tapped
                        }
                        .onAppear {
                            if viewModel.hasReachedEnd(of: comment) && !viewModel.isFetching {
                                viewModel.loadMoreData()
                            }
                        }
                }
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.isFetching || viewModel.isLoading {
                ProgressView()
            }
        }
        .listStyle(.plain)
        .padding(.top, 8)
        .foregroundColor(.primary)
    }
}
