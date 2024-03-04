//
//  PostListViewController.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 2/14/24.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    @IBOutlet weak var postsTable: UITableView!
    var searchController: UISearchController!
    
    var filterButton: UIBarButtonItem!
    var filterButtonEnabled: Bool = false
    
    var viewModel: PostsViewModel!
    
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
        viewModel = PostsViewModel(subreddit: "ios", limit: 10, after: nil)
        viewModel.onPostsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.postsTable.reloadData()
            }
        }
        setupNavigationBar()
        setupSearchButton()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        self.title = "/r/\(viewModel.subreddit)"
        let filterIcon = UIImage(systemName: "slider.horizontal.3")
        filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(filterButtonTapped))
        filterButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = filterButton
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func setupSearchButton() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.delegate = self
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 237/255, alpha: 1) // Set your desired color here
        }
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
    }
    
    private func setupTableView() {
        postsTable.dataSource = self
        postsTable.delegate = self
        postsTable.estimatedRowHeight = 310
        postsTable.rowHeight = UITableView.automaticDimension
//        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit(_:)))
//        postsTable.addGestureRecognizer(singleTapGesture)
    }

    
    @objc private func filterButtonTapped() {
        filterButtonEnabled.toggle()
        if filterButtonEnabled {
            navigationItem.searchController = searchController
            viewModel.inSearchMode = true
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            navigationItem.searchController = nil
            viewModel.inSearchMode = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
    
 
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.isLoading {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
            let spinner = UIActivityIndicatorView()
            spinner.center = footerView.center
            footerView.addSubview(spinner)
            spinner.startAnimating()
            DispatchQueue.main.async {
                self.postsTable.tableFooterView = footerView
            }
        } else {
            DispatchQueue.main.async {
                self.postsTable.tableFooterView = nil
            }
        }
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
        if !viewModel.isFirstRequest && viewModel.after == nil {
            return
        }
        let position = scrollView.contentOffset.y
        if position > (postsTable.contentSize.height - 330 - scrollView.frame.size.height) {
            if !viewModel.isLoading {
                viewModel.loadPosts(subreddit: viewModel.subreddit, limit: 10, after: viewModel.after)
            }
        }
    }
    
//    @objc func tapEdit(_ gesture: UITapGestureRecognizer)  {
//        guard gesture.state != .began else { return }
//        let tapLocation = gesture.location(in: self.postsTable)
//        if let indexPath = self.postsTable.indexPathForRow(at: tapLocation) {
//            if let tappedCell = self.postsTable.cellForRow(at: indexPath) as? PostCell {
//                let postDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
//                postDetailsVC.viewModel = viewModel
//                postDetailsVC.post = viewModel.displayedPosts[indexPath.row]
//                navigationController?.pushViewController(postDetailsVC, animated: true)
//
//            }
//        }
//    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer == singleTapGestureRecognizer && otherGestureRecognizer == doubleTapGestureRecognizer {
//            return true
//        }
//        return false
//    }
}

extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        let rowData = viewModel.displayedPosts[indexPath.row]
        cell.configure(with: rowData, delegateForPostView: self)
        cell.delegate = self
        return cell
    }
    

}

extension PostListViewController: PostDetailsViewDelegate {
    func saveButtonTapped(for post: Post) {
        if viewModel.isPostSaved(post) {
            viewModel.unsavePost(post)
        } else {
            viewModel.savePost(post)
        }
    }
}

extension PostListViewController: PostTableViewCellDelegate {
    func didSelectPost(_ post: Post) {
        print("hello in did select post")
        let postDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
        postDetailsVC.viewModel = viewModel
        postDetailsVC.post = post
        navigationController?.pushViewController(postDetailsVC, animated: true)
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let postDetailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostDetailsViewController") as! PostDetailsViewController
//        postDetailsVC.viewModel = viewModel
//        postDetailsVC.post = viewModel.displayedPosts[indexPath.row]
//        navigationController?.pushViewController(postDetailsVC, animated: true)
//    }
    
}

extension PostDetailsViewDelegate where Self: UIViewController {
    func shareButtonTapped(for post: Post) {
        let items = [URL(string: "https://www.reddit.com\(post.url ?? "")")!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
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
//    func getPosts(subreddit: String, limit: Int, after: String?) {
//        isLoading = true
//        self.postsTable.tableFooterView = createSpinnerFooter()
//        Task(priority: .background) {
//            let result = await postsService.getPostDetail(subreddit: subreddit, limit: limit, after: after)
//            self.postsTable.tableFooterView = nil
//            switch result {
//            case .success(let postData):
//                self.after = postData.data.after
//                self.posts.append(contentsOf: postData.data.children.map { $0.data })
//                DispatchQueue.main.async {
//                    self.postsTable.reloadData()
//                }
//                self.isLoading = false
//                self.isFirstRequest = false
//
//            case .failure(let error):
//                print("Failed to fetch post detail: \(error)")
//            }
//        }
//    }


//    func getPosts(subreddit: String, limit: Int, after: String?) {
//        isLoading = true
//        self.postsTable.tableFooterView = createSpinnerFooter()
//        viewModel.loadPosts(subreddit: subreddit, limit: limit, after: after) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.postsTable.tableFooterView = nil
//            }
//            switch result {
//            case .success(let (after, posts)):
//                self.after = after
//                self.viewModel.savePosts(posts)
//                DispatchQueue.main.async {
//                    self.postsTable.reloadData()
//                }
//                self.isLoading = false
//                self.isFirstRequest = false
//
//            case .failure(let error):
//                print("Failed to fetch post detail: \(error)")
//            }
//        }
//    }
