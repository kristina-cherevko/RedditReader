//
//  PostDetailsCell.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit

class PostCell: UITableViewCell {
    
    @IBOutlet private weak var postCellView: PostView!
//    private weak var delegate: PostDetailsViewDelegate?
    
    func configure(with post: Post?, delegate: PostDetailsViewDelegate?) {
        postCellView.delegate = delegate
        postCellView.configure(with: post)
        
    }
}
