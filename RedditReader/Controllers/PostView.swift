//
//  PostDetailsView.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit

protocol PostDetailsViewDelegate: AnyObject {
    func shareButtonTapped(for post: Post)
    func saveButtonTapped(for post: Post)
}

class PostView: UIView {
    private let kCONTENT_XIB_NAME = "PostDetailsView"

    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var domain: UILabel!
    @IBOutlet private weak var bookmarkButton: UIButton!
    
    
    @IBOutlet private weak var postTitle: UILabel!
    @IBOutlet private weak var postImage: UIImageView!
    @IBOutlet private weak var rating: UIButton!
    @IBOutlet private weak var commentsCount: UIButton!
    @IBOutlet private weak var shareButton: UIButton!

    private var bookmarkImageView: UIView!
    var post: Post?
    weak var delegate: PostDetailsViewDelegate?
    var doubleTapGestureRecognizer: UITapGestureRecognizer!
    
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
    
    func configure(with post: Post?) {
        if let post = post {
            self.post = post
            self.username.text = post.authorFullname ?? "unknown"
            self.domain.text = post.domain
            self.postTitle.text = post.title
            self.rating.setTitle(String(post.ups - post.downs), for: .normal)
            self.commentsCount.setTitle(String(post.numComments), for: .normal)
            self.createdAt.text = "\(Int((Int(Date().timeIntervalSince1970) - post.created) / 3600))h ago"
            
            let bookmarkImage = post.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
            self.bookmarkButton.setImage(bookmarkImage, for: .normal)
            if let imageUrl = formatImageUrl(in: post) {
                self.postImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder-image.png"))
            } else {
                self.postImage.image = UIImage(named: "placeholder-image.png")
            }
        }
        self.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        self.bookmarkImageView?.removeFromSuperview()
        self.bookmarkImageView = BookmarkIconView()
        self.bookmarkImageView.isHidden = true
        addSubview(bookmarkImageView)
        setupImageGestureRecognizer()
    }
    
    
    
    private func setupImageGestureRecognizer() {
        self.postImage.isUserInteractionEnabled = true
        doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        self.postImage.addGestureRecognizer(doubleTapGestureRecognizer)
    }
    
//  MARK: button click handler
    @objc private func bookmarkButtonTapped() {
        post?.saved.toggle()
        let bookmarkImage = post!.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        self.bookmarkButton.setImage(bookmarkImage, for: .normal)
        delegate?.saveButtonTapped(for: post!)
    }
    
    @objc private func imageTapped(_ gesture: UITapGestureRecognizer) {
        

        guard gesture.state == .ended else { return }
        
        self.bookmarkImageView.center = contentView.center
        
        self.bookmarkImageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.bookmarkImageView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1, options:
                .curveEaseInOut, animations: {
            self.bookmarkImageView.transform = .identity
            self.bookmarkImageView.isHidden = false
            self.bookmarkImageView.alpha = 1.0
//            print("hello")
        }, completion: { _ in
            self.post?.saved.toggle()
            let bookmarkImage = self.post!.saved ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
                    self.bookmarkButton.setImage(bookmarkImage, for: .normal)
            self.delegate?.saveButtonTapped(for: self.post!)
            UIView.animate(withDuration: 1, animations: {
                self.bookmarkImageView.alpha = 0.0
            }) { _ in
                self.bookmarkImageView.isHidden = true
            }
            
        }
        )
        
    }
    
    @objc private func shareButtonTapped() {
        guard let post = post else {
            return
        }
        // Call the delegate method
        delegate?.shareButtonTapped(for: post)
    }
    

//  MARK: format image URL
    func formatImageUrl(in post: Post) -> String? {
        if let initialImageUrl = post.preview?.images.first?.source.url {
            return initialImageUrl.replacingOccurrences(of: "&amp;", with: "&")
        }
        return nil
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


