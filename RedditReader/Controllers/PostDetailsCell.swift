//
//  PostDetailsCell.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit

class PostDetailsCell: UITableViewCell {
    
    @IBOutlet weak var postCellView: PostDetailsView!
    
    func configure(for postRow: Post) {
//        print("row \(postRow)")
        self.postCellView.username.text = postRow.authorFullname
        self.postCellView.domain.text = postRow.domain
        self.postCellView.postTitle.text = postRow.title
//        self.postCellView.postTitle.text = postRow.title
        self.postCellView.rating.setTitle(String(postRow.ups - postRow.downs), for: .normal)
        self.postCellView.commentsCount.setTitle(String(postRow.numComments), for: .normal)
        self.postCellView.createdAt.text = "\(Int((Int(Date().timeIntervalSince1970) - postRow.created) / 3600))h ago"
        let bookmarkImage = postRow.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        self.postCellView.bookmarkButton.setImage(bookmarkImage, for: .normal)
        if let imageUrl = formatImageUrl(in: postRow) {
            self.postCellView.postImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder-image.png"))
        } else {
            self.postCellView.postImage.image = UIImage(named: "placeholder-image.png")
        }
    }

    
    //  MARK: format image URL
    func formatImageUrl(in post: Post) -> String? {
        if let initialImageUrl = post.preview?.images.first?.source.url {
            return initialImageUrl.replacingOccurrences(of: "&amp;", with: "&")
        }
        return nil
    }
}
