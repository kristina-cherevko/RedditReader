//
//  ViewController.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/9/24.
//

import UIKit
import SDWebImage

class PostDetailsViewController: UIViewController {


//    @IBOutlet weak var postDetailsView: PostDetailsView!
    
    @IBOutlet weak var postDetailsView: PostDetailsView!
    var post: Post?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
//            post = postDetails
            postDetailsView.username.text = post.authorFullname
            postDetailsView.domain.text = post.domain
            postDetailsView.postTitle.text = post.title
            postDetailsView.rating.setTitle(String(post.ups - post.downs), for: .normal)
            postDetailsView.commentsCount.setTitle(String(post.numComments), for: .normal)
            postDetailsView.createdAt.text = "\(Int((Int(Date().timeIntervalSince1970) - post.created) / 3600))h ago"
            let bookmarkImage = post.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
            postDetailsView.bookmarkButton.setImage(bookmarkImage, for: .normal)
            if let imageUrl = formatImageUrl(in: post) {
                postDetailsView.postImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder-image.png"))
            } else {
                postDetailsView.postImage.image = UIImage(named: "placeholder-image.png")
            }
        }
//        print("PostDetailsViewCOntroller finished loading")
        postDetailsView.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
    }
    

    
//  MARK: button click handler
    @objc private func bookmarkButtonTapped() {
        post?.saved.toggle()
        let bookmarkImage = post!.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        postDetailsView.bookmarkButton.setImage(bookmarkImage, for: .normal)
    }
    

    

//  MARK: format image URL
    func formatImageUrl(in post: Post) -> String? {
        if let initialImageUrl = post.preview?.images.first?.source.url {
            return initialImageUrl.replacingOccurrences(of: "&amp;", with: "&")
        }
        return nil
    }
    



}

