//
//  PostListViewController.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit


class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
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
        
        postsTable.dataSource = self
        postsTable.delegate = self
        postsTable.prefetchDataSource = self
        
        self.title = "/r/\(subreddit)"
        let filterIcon = UIImage(systemName: "slider.horizontal.3")
        let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = filterButton
        
//        isFirstRequest = true
        
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
        cell.configure(for: rowData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        print("Prefetch: \(indexPaths)")
        // Check if it's not the first request and 'after' is nil
        if !isFirstRequest && after == nil {
            print("No 'after' value provided. Stopping further requests.")
            return
        }
        
        if let lastIndexPath = indexPaths.last, lastIndexPath.row == posts.count - 1 {
            if !isLoading {
                isLoading = true
                getPosts(subreddit: subreddit, limit: 10, after: after)
            }
        }
    }
    
    
//  MARK: pass data to PostDetailsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetailsSegue" {
           if let postDetailsVC = segue.destination as? PostDetailsViewController,
              let selectedRow = postsTable.indexPathForSelectedRow?.row {
//               print(posts[selectedRow])
               postDetailsVC.post = posts[selectedRow]
           }
       }
    }
    
    
//  MARK: request posts data
    func getPosts(subreddit: String, limit: Int, after: String?) {
        Task(priority: .background) {
//            print("after is \(after)")
            let result = await postsService.getPostDetail(subreddit: subreddit, limit: limit, after: after)
            switch result {
            case .success(let postData):
                self.after = postData.data.after
                self.posts.append(contentsOf: postData.data.children.map { $0.data })
//                DispatchQueue.main.async {
                self.postsTable.reloadData()
                self.isLoading = false
                self.isFirstRequest = false
//                }
            case .failure(let error):
                print("Failed to fetch post detail: \(error)")
            }
        }
    }
}
