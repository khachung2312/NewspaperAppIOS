//
//  ListPostsViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit

class ListPostsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var cvListPosts: UICollectionView!
    var postsData: [PostsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        cvListPosts.delegate = self
        cvListPosts.dataSource = self
        cvListPosts.allowsMultipleSelectionDuringEditing = true
        cvListPosts.isEditing = true
        
        cvListPosts.register(UINib(nibName: "MyPostsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyPostsCellIdentifier")
        
        callAPIGetPosts()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cvListPosts.reloadData()
    }
    
    
    func callAPIGetPosts() {
        let apiHandler = APIHandler()
        apiHandler.getAllPostsByIdUser() { postsResponseData in
            self.postsData = postsResponseData
            self.cvListPosts.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvListPosts.dequeueReusableCell(withReuseIdentifier: "MyPostsCellIdentifier", for: indexPath) as! MyPostsCollectionViewCell
        
        cell.layer.cornerRadius = 5
        cell.lblTitle.text = postsData[indexPath.row].title
        let imgURL = URL(string: postsData[indexPath.row].avatar)
        cell.imgAvatarPosts.kf.setImage(with: imgURL)
        
        cell.onDelete = { [weak self] in
            guard let self = self else { return }
            
            let post = self.postsData[indexPath.row]
            APIHandler().deletePost(id: post.id) { success in
                if success {
                    self.postsData.remove(at: indexPath.row)
                    self.cvListPosts.deleteItems(at: [indexPath])
                } else {
                    // Handle error
                }
            }
            
        }
        
        return cell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "InsertOrUpdateVC") as! InsertOrUpdateViewController
        let id = postsData[indexPath.row].id
        let idUser = postsData[indexPath.row].idUser
        let posts = PostsModel(id: id, idUser: idUser, avatar: "\(postsData[indexPath.row].avatar)", title: "\(postsData[indexPath.row].title)", content: "\(postsData[indexPath.row].content)", category: "\(postsData[indexPath.row].category)")
        detailVC.posts = posts
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
}

extension ListPostsViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        callAPIGetPosts()
    }
}

extension ListPostsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 20) / 2 - 0.00001, height: 235)
    }
    
}

