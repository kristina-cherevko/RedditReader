//
//  PostDetailsViewDelegate.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/15/24.
//

import UIKit

extension PostDetailsViewDelegate where Self: UIViewController {
    func shareButtonTapped(for post: Post) {
        let items = [URL(string: "https://www.reddit.com\(post.url ?? "")")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
