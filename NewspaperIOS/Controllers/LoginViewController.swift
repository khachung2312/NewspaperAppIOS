//
//  LoginViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 22/07/2023.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnLoginOutlet: UIButton!
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var txtPassWord: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLogin.layer.cornerRadius = 25
        viewLogin.layer.shadowColor = UIColor.black.cgColor
        viewLogin.layer.shadowOpacity = 0.5
        viewLogin.layer.shadowOffset = CGSize(width: 0, height: 10)
        viewLogin.layer.shadowRadius = 10
        btnLoginOutlet.layer.cornerRadius = 17
        
        
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func goToHomeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! UITabBarController
        navigationController?.setViewControllers([homeVC], animated: true)
        homeVC.navigationItem.hidesBackButton = true
        
    }
    
    func callAPILogin(username: String, password: String) {
        let apiHandler = APIHandler()
        apiHandler.loginUser(username: username, password: password) { (success, user) in
            if success {
                UserDefaults.standard.setValue(user, forKey: "user")
                print(user!)
                self.goToHomeVC()
                
            } else {
                self.showError("Đăng nhập không thành công. Tài khoản hoặc mật khẩu không chính xác!")
            }
        }
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        guard let username = txtUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty,
              let password = txtPassWord.text?.trimmingCharacters(in: .whitespacesAndNewlines), !password.isEmpty else {
            showError("Vui lòng điền đầy đủ thông tin.")
            return
        }
        callAPILogin(username: username, password: password)
    }
    
    
}
