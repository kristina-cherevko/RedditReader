//
//  ViewController.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/9/24.
//

import UIKit
import SDWebImage

class PostViewController: UIViewController {

    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var commentsCount: UIButton!
    @IBOutlet private weak var share: UIButton!
    @IBOutlet private weak var postImage: UIImageView!
    
    let postsService = PostsService()
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchPostDetail()
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
                
    }
    
    @objc private func bookmarkButtonTapped() {
        let isSaved = post?.saved
        post?.saved = !isSaved!
        let bookmarkImage = post!.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        bookmarkButton.setImage(bookmarkImage, for: .normal)
    }
    
    func fetchPostDetail() {
        Task(priority: .userInitiated) {
            let result = await postsService.getPostDetail(subreddit: "ios", limit: 1, after: nil)
            switch result {
            case .success(let postData):
                post = postData.data.children.first?.data
                self.updatePostView(with: post)
            case .failure(let error):
                print("Failed to fetch post detail: \(error)")
            }
            
        }
    }
    
    

    func updatePostView(with post: Post?) {
        guard let post = post else {
            return
        }
        username.text = post.authorFullname
        domain.text = post.domain
        postTitle.text = post.title
        print("\(post.numComments)")
        rating.setTitle(String(post.ups - post.downs), for: .normal)
        commentsCount.setTitle(String(post.numComments), for: .normal)
        createdAt.text = "\(Int((Int(Date().timeIntervalSince1970) - post.created) / 3600))h ago"
        let bookmarkImage = post.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        bookmarkButton.setImage(bookmarkImage, for: .normal)
        if let imageUrl = formatImageUrl(in: post) {
            postImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder-image.png"))
        } else {
            postImage.image = UIImage(named: "placeholder-image.png")
        }
    }
    

    
    func formatImageUrl(in post: Post) -> String? {
        if let initialImageUrl = post.preview?.images.first?.source.url {
            print(initialImageUrl)
            return initialImageUrl.replacingOccurrences(of: "&amp;", with: "&")
        }
        return nil
    }
    



}

