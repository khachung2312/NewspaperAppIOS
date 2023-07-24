//
//  HomeViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var btnCategoryTourism: UIButton!
    @IBOutlet weak var btnCategoryNews: UIButton!
    @IBOutlet weak var btnCategoryCulture: UIButton!
    @IBOutlet weak var btnCategorySport: UIButton!
    @IBOutlet weak var btnCategoryAllOutlet: UIButton!
    @IBOutlet weak var tblPosts: UITableView!
    @IBOutlet weak var btnSearchOutlet: UIButton!
    @IBOutlet weak var cvBanner: UICollectionView!
    @IBOutlet weak var viewSearch: UIView!
    
    var bannerData: [UIImage] = []
    var bannerTimer: Timer?
    var currentBannerIndex: Int = 0
    var postsData: [PostsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSearch.layer.cornerRadius = 17
        btnSearchOutlet.layer.cornerRadius = 17
        cvBanner.dataSource = self
        cvBanner.delegate = self
        tblPosts.dataSource = self
        tblPosts.delegate = self
        cvBanner.layer.cornerRadius = 10
        
        tblPosts.register(UINib(nibName: "PostsTableViewCell", bundle: nil), forCellReuseIdentifier: "PostsCellIdentifier")
        cvBanner.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCellIdentifier")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        cvBanner.collectionViewLayout = layout
        loadBannerImages()
        startBannerTimer()
        callAPIGetPosts()
        self.tabBarController?.delegate = self
    }
    
    func loadBannerImages() {
        for i in 1...4 {
            let imageName = "banner\(i)"
            if let image = UIImage(named: imageName) {
                bannerData.append(image)
            }
        }
    }
    
    func startBannerTimer() {
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.currentBannerIndex = (self.currentBannerIndex + 1) % self.bannerData.count
            let nextIndexPath = IndexPath(item: self.currentBannerIndex, section: 0)
            self.cvBanner.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCellIdentifier", for: indexPath) as! BannerCollectionViewCell
        cell.imgBanner.image = bannerData[indexPath.item]
        return cell
    }
    
    
    func callAPIGetPosts() {
        APIHandler.init().getPosts(){
            postsResponseData in
            self.postsData = postsResponseData
            self.tblPosts.reloadData()
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPosts.dequeueReusableCell(withIdentifier: "PostsCellIdentifier") as! PostsTableViewCell
        let imgURL = URL(string: postsData[indexPath.row].avatar)
        cell.imgAvatarPosts.kf.setImage(with: imgURL)
        cell.lblTitle.text = postsData[indexPath.row].title
        cell.lblCategory.text = postsData[indexPath.row].category
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailPostsVC") as! DetailPostsViewController
        let posts = PostsModel(id: 0, idUser: 0, avatar: "\(postsData[indexPath.row].avatar)", title: "\(postsData[indexPath.row].title)", content: "\(postsData[indexPath.row].content)", category: "\(postsData[indexPath.row].category)")
        detailVC.posts = posts
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let clousePosts = UITableViewRowAction(style: .destructive, title: "Đóng") { (action, indexPath) in
            self.postsData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        clousePosts.backgroundColor = .gray
        return [clousePosts]
    }
    
    @IBAction func btnCategoryAll(_ sender: UIButton) {
        callAPIGetPosts()
        btnCategoryAllOutlet.tintColor = .black
        btnCategorySport.tintColor = .lightGray
        btnCategoryCulture.tintColor = .lightGray
        btnCategoryNews.tintColor = .lightGray
        btnCategoryTourism.tintColor = .lightGray
    }
    
    @IBAction func btnCategorySport(_ sender: UIButton) {
        btnCategoryAllOutlet.tintColor = .lightGray
        btnCategorySport.tintColor = .black
        btnCategoryCulture.tintColor = .lightGray
        btnCategoryNews.tintColor = .lightGray
        btnCategoryTourism.tintColor = .lightGray
        guard let category = sender.titleLabel?.text else {
            return
        }
        let apiHandler = APIHandler()
        apiHandler.searchPosts(category: category) { (posts) in
            DispatchQueue.main.async {
                self.postsData = posts
                self.tblPosts.reloadData()
            }
        }
    }
    
    @IBAction func btnCategoryCulture(_ sender: UIButton) {
        btnCategoryAllOutlet.tintColor = .lightGray
        btnCategorySport.tintColor = .lightGray
        btnCategoryCulture.tintColor = .black
        btnCategoryNews.tintColor = .lightGray
        btnCategoryTourism.tintColor = .lightGray
        guard let category = sender.titleLabel?.text else {
            return
        }
        let apiHandler = APIHandler()
        apiHandler.searchPosts(category: category) { (posts) in
            DispatchQueue.main.async {
                self.postsData = posts
                self.tblPosts.reloadData()
            }
        }
    }
    
    @IBAction func btnCategoryNews(_ sender: UIButton) {
        btnCategoryAllOutlet.tintColor = .lightGray
        btnCategorySport.tintColor = .lightGray
        btnCategoryCulture.tintColor = .lightGray
        btnCategoryNews.tintColor = .black
        btnCategoryTourism.tintColor = .lightGray
        guard let category = sender.titleLabel?.text else {
            return
        }
        let apiHandler = APIHandler()
        apiHandler.searchPosts(category: category) { (posts) in
            DispatchQueue.main.async {
                self.postsData = posts
                self.tblPosts.reloadData()
            }
        }
    }
    
    @IBAction func btnCategoryTourism(_ sender: UIButton) {
        btnCategoryAllOutlet.tintColor = .lightGray
        btnCategorySport.tintColor = .lightGray
        btnCategoryCulture.tintColor = .lightGray
        btnCategoryNews.tintColor = .lightGray
        btnCategoryTourism.tintColor = .black
        guard let category = sender.titleLabel?.text else {
            return
        }
        let apiHandler = APIHandler()
        apiHandler.searchPosts(category: category) { (posts) in
            DispatchQueue.main.async {
                self.postsData = posts
                self.tblPosts.reloadData()
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 326, height: 172
        )
    }
    
}

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        callAPIGetPosts()
        
    }
}
