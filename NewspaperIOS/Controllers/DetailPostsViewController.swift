//
//  DetailPostsViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit
import Kingfisher

class DetailPostsViewController: UIViewController {
    var posts = PostsModel(id: 1, idUser: 1, avatar: "", title: "", content: "", category: "")
    
    
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatarPosts: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgURL = URL(string: posts.avatar)
        self.imgAvatarPosts.kf.setImage(with: imgURL)
        self.lblTitle.text = posts.title
        self.lblContent.text = posts.content
        self.lblCategory.text = posts.category
        
    }
    
    
    @IBAction func btnLogout(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.setViewControllers([registerVC], animated: false)
        registerVC.navigationItem.hidesBackButton = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
