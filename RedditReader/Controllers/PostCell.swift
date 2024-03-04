//
//  PostDetailsCell.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit

protocol PostTableViewCellDelegate: AnyObject {
    func didSelectPost(_ post: Post)
}

class PostCell: UITableViewCell {
    
    @IBOutlet private weak var postCellView: PostView!
    weak var delegate: PostTableViewCellDelegate?
    
    func configure(with post: Post?, delegateForPostView: PostDetailsViewDelegate?) {
        postCellView.delegate = delegateForPostView
        postCellView.configure(with: post)
        setupTapGestureRecognizer()
    }
    
    private func setupTapGestureRecognizer() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)
        singleTapGesture.require(toFail: postCellView.doubleTapGestureRecognizer)
    }
    
    @objc func handleSingleTap(_ gesture: UITapGestureRecognizer) {
          guard let post = postCellView.post else { return }
          delegate?.didSelectPost(post)
      }
}

