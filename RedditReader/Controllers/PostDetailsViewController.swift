//
//  ViewController.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/9/24.
//

import UIKit
import SwiftUI

class PostDetailsViewController: UIViewController, PostDetailsViewDelegate {
   
    @IBOutlet private weak var postDetailsView: PostView!
    var post: Post?
    var viewModel: PostsViewModel?
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSwiftUIView()
        if let post = post {
            postDetailsView.configure(with: post)
        }
        postDetailsView.delegate = self
    }
    
    private func initSwiftUIView() {
        guard let post = post else {
            return
        }
        // 1. Embed SwiftUI view in UIHostingController
        var commentsView = CommentsView(viewModel: CommentsViewModel(subreddit: post.subreddit, postId: post.id)) { [weak self] comment in
            self?.showCommentDetails(comment: comment)
        }
        commentsView.didSelectComment = { [weak self] comment in
            self?.showCommentDetails(comment: comment)
        }
        let swiftUIViewController = UIHostingController(rootView: commentsView)

        // 2. Get reference to the HostingController view (UIView)
        let swiftUIView: UIView = swiftUIViewController.view
        // 3. Put `swiftUIView` in `containerView`
        self.containerView.addSubview(swiftUIView)

        // 4. Layout with constraints
        swiftUIView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            swiftUIView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            swiftUIView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            swiftUIView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            swiftUIView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor)
        ])

        // 5. Notify child View Controller of being presented
        swiftUIViewController.didMove(toParent: self)
    }
    
    func saveButtonTapped(for post: Post) {
//        print("save button tapped in view controller")
        if viewModel!.isPostSaved(post) {
            viewModel!.unsavePost(post)
        } else {
            viewModel!.savePost(post)
        }
    }
    
    func showCommentDetails(comment: Comment) {
        let commentDetailsViewController = UIHostingController(rootView: CommentDetailsView(comment: comment))
        navigationController?.pushViewController(commentDetailsViewController, animated: true)
    }
}

