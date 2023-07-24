//
//  RegisterViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 20/07/2023.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEnterPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnRegisterOutlet: UIButton!
    @IBOutlet weak var viewBackgroundWhite: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBackgroundWhite.layer.cornerRadius = 25
        btnRegisterOutlet.layer.cornerRadius = 17
    }
    
    func validateFields() -> String? {
        if txtUserName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtFullName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtPhone.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtEnterPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Vui lòng điền đầy đủ thông tin."
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailPredicate.evaluate(with: txtEmail.text) {
            return "Email không hợp lệ."
        }
        
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        if !passwordPredicate.evaluate(with: txtPassword.text) {
            return "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số."
        }
        
        if txtPassword.text != txtEnterPassword.text {
            return "Mật khẩu và xác nhận mật khẩu không khớp."
        }
        
        return nil
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Lỗi", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showSuccess() {
        let alert = UIAlertController(title: "Thành công", message: "Đăng ký tài khoản thành công!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func btnRegisterAccount(_ sender: UIButton) {
        let error = validateFields()
        
        if error != nil {
            showError(error!)
        } else {
            let username = txtUserName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fullname = txtFullName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let phone = txtPhone.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let apiHandler = APIHandler()
            apiHandler.registerUser(username: username, fullname: fullname, email: email, phone: phone, password: password) { success in
                if success {
                    self.showSuccess()
                } else {
                    self.showError("Đăng ký tài khoản thất bại.")
                }
            }
        }
    }
    
    @IBAction func btnGoToLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
