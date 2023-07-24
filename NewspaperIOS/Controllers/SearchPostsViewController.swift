//
//  SearchPostsViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit
import Kingfisher

class SearchPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblAlert: UILabel!
    var postsData: [PostsModel] = []
    var filteredPostsData: [PostsModel] = []
    var postsSearchText: String?
    @IBOutlet weak var tblSearhPosts: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSearhPosts.dataSource = self
        tblSearhPosts.delegate = self
        searchBar.delegate = self
        tblSearhPosts.register(UINib(nibName: "SearchPostsTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchPostsCellIdentifier")
        tblSearhPosts.isHidden = true
        callAPIGetPosts()
        
        
    }
    func callAPIGetPosts() {
        APIHandler().getPosts{ postsResponseData in
            self.postsData = postsResponseData
            self.filteredPostsData = self.postsData
            self.tblSearhPosts.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPostsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSearhPosts.dequeueReusableCell(withIdentifier: "SearchPostsCellIdentifier") as! SearchPostsTableViewCell
        cell.lblTitle.text = filteredPostsData[indexPath.row].title
        cell.lblCategory.text = filteredPostsData[indexPath.row].category
        cell.imgAvatarPosts.kf.setImage(with: URL(string: filteredPostsData[indexPath.row].avatar))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredPostsData = postsData
            tblSearhPosts.isHidden = true
            lblAlert.text = "Danh sách tìm kiếm"
            imgIcon.isHidden = true
        } else {
            filteredPostsData = postsData.filter { $0.title.uppercased().contains(searchText.uppercased()) }
            tblSearhPosts.isHidden = filteredPostsData.isEmpty
            lblAlert.text = "Không tìm thấy bài viết"
            imgIcon.isHidden = false
        }
        tblSearhPosts.reloadData()
    }
    
    
    
    
}
