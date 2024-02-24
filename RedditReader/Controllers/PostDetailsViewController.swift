//
//  ViewController.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/9/24.
//

import UIKit

class PostDetailsViewController: UIViewController, PostDetailsViewDelegate {
   
    @IBOutlet private weak var postDetailsView: PostDetailsView!
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post = post {
            postDetailsView.configure(with: post)
        }
        postDetailsView.delegate = self
    }
        
    func saveButtonTapped(for post: Post) {
        print("save button tapped in view controller")
        if PostRepository.shared.isPostSaved(post) {
            PostRepository.shared.unsavePost(post)
        } else {
            PostRepository.shared.savePost(post)

        }
    }
}

