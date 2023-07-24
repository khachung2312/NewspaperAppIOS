//
//  UserInfoViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var btnLogoutOutlet: UIButton!
    @IBOutlet weak var btnListPostsOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserDefaults.standard.dictionary(forKey: "user") {
            let fullname = user["fullName"] as? String
            let email = user["email"] as? String
            let phone = user["phone"] as? String
            lblFullName.text = fullname
            lblEmail.text = email
            lblPhone.text = phone
            
        }
        btnLogoutOutlet.layer.cornerRadius = 5
        btnListPostsOutlet.layer.cornerRadius = 5
        imgAvatar.layer.cornerRadius = 74
        imgAvatar.layer.borderWidth = 2
    }
    
    @IBAction func btnLogOut(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: "user")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginViewController)
        UIApplication.shared.windows.first?.rootViewController = navigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
}
