//
//  PostDetailsView.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit

class PostDetailsView: UIView {
    let kCONTENT_XIB_NAME = "PostDetailsView"

    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    
    @IBOutlet weak var postTitle: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var rating: UIButton!
    
    @IBOutlet weak var commentsCount: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
            contentView.fixInView(self)
        }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
