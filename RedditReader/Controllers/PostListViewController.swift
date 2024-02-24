//
//  PostListViewController.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var postsTable: UITableView!
    
    var posts = [Post]()
    let postsService = PostsService()
    let subreddit = "ios"
    var after: String? = nil
    var isLoading = false
    var isFirstRequest = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 255/255, green: 86/255, blue: 0/255, alpha: 1.0)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posts = PostDataManager.shared.loadPosts()
        
        postsTable.dataSource = self
        postsTable.delegate = self
        
        self.title = "/r/\(subreddit)"
        let filterIcon = UIImage(systemName: "slider.horizontal.3")
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = filterButton
                
        postsTable.estimatedRowHeight = 310
        postsTable.rowHeight = UITableView.automaticDimension
        
        getPosts(subreddit: subreddit, limit: 10, after: after)
    }
    
    @objc private func filterButtonTapped() {
        print("Test filter button in PostListViewController")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostDetailsCell
        let rowData = posts[indexPath.row]
        cell.configure(with: rowData, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        postDetailsVC.post = posts[indexPath.row]
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isFirstRequest && after == nil {
            return
        }
        let position = scrollView.contentOffset.y
        if position > (postsTable.contentSize.height - 330 - scrollView.frame.size.height) {
            if !isLoading {
                getPosts(subreddit: subreddit, limit: 10, after: after)
            }
        }
    }
    
//  MARK: pass data to PostDetailsViewController
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "postDetailsSegue" {
//           if let postDetailsVC = segue.destination as? PostDetailsViewController,
//              let selectedRow = postsTable.indexPathForSelectedRow?.row {
//               postDetailsVC.post = posts[selectedRow]
//           }
//       }
//    }
    
//  MARK: request posts data
    func getPosts(subreddit: String, limit: Int, after: String?) {
        isLoading = true
        self.postsTable.tableFooterView = createSpinnerFooter()
        Task(priority: .background) {
            let result = await postsService.getPostDetail(subreddit: subreddit, limit: limit, after: after)
            self.postsTable.tableFooterView = nil
            switch result {
            case .success(let postData):
                self.after = postData.data.after
                self.posts.append(contentsOf: postData.data.children.map { $0.data })
                DispatchQueue.main.async {
                    self.postsTable.reloadData()
                }
                self.isLoading = false
                self.isFirstRequest = false

            case .failure(let error):
                print("Failed to fetch post detail: \(error)")
            }
        }
    }
    

}


extension PostListViewController: PostDetailsViewDelegate {
    func saveButtonTapped(for post: Post) {
        print("save button tapped in view controller or cell")
        if PostRepository.shared.isPostSaved(post) {
            PostRepository.shared.unsavePost(post)
        } else {
            PostRepository.shared.savePost(post)
        }
        print("posts \(posts)")
//        posts = postRepository.getPosts()
        DispatchQueue.main.async {
            self.postsTable.reloadData()
        }
    }
 
}

extension PostDetailsViewDelegate where Self: UIViewController {
    
    func shareButtonTapped(for post: Post) {
        print("hello world in share button in cell!")
        let items = [URL(string: "https://www.reddit.com/r/ios/top.json")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
  
}
