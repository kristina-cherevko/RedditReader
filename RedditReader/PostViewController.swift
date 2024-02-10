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
    @IBOutlet private weak var bookmarkLabel: UIButton!
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var commentsCount: UIButton!
    @IBOutlet private weak var share: UIButton!
    @IBOutlet weak var postImage: UIImageView!
    
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updatePostView()
    }
    
    func updatePostView() {

        username.text = "myusername"
        domain.text = "domain"
        postTitle.text = "This is a tuitle"
        rating.setTitle("14", for: .normal)
        commentsCount.setTitle("43", for: .normal)
        createdAt.text = "10h ago"

        let bookmarkImage = UIImage(systemName: "bookmark.fill")
        bookmarkLabel.setImage(bookmarkImage, for: .normal)
        
        if let image = UIImage(named: "kittens.jpg") {
            // Set the image to the UIImageView
            postImage.image = image
        } else {
            // Handle the case where the image could not be loaded
            print("Error: Couldn't load the image")
        }
    }

}

