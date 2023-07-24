//
//  InsertOrUpdateViewController.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit
import Alamofire

class InsertOrUpdateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var posts = PostsModel(id: 0, idUser: 0, avatar: "", title: "", content: "", category: "")
    let categorys = ["Thể thao", "Văn hoá", "Tin tức", "Du lịch"]
    
    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var txtTitlePosts: UITextField!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var btnCategoryOutlet: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewInput: UIView!
    @IBOutlet weak var btnSaveOutlet: UIButton!
    @IBOutlet weak var btnCancelOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSaveOutlet.layer.cornerRadius = 20
        btnCancelOutlet.layer.cornerRadius = 20
        btnCancelOutlet.layer.borderWidth = 1
        viewInput.layer.cornerRadius = 20
        viewInput.layer.borderWidth = 2
        viewInput.layer.borderColor = UIColor.gray.cgColor
        tblCategory.layer.borderWidth = 0.5
        btnCancelOutlet.layer.borderColor = UIColor.gray.cgColor
        btnCategoryOutlet.layer.cornerRadius = 5
        btnCategoryOutlet.layer.borderWidth = 0.5
        btnCategoryOutlet.layer.borderColor = UIColor.lightGray.cgColor
        
        if posts.id == 0 {
            self.lblTitle.text = "Thêm bài viết"
        } else {
            let imgURL = URL(string: posts.avatar)
            self.imgAvatar.kf.setImage(with: imgURL)
            self.txtTitlePosts.text = posts.title
            self.txtContent.text = posts.content
            self.btnCategoryOutlet.titleLabel?.text = posts.category
            self.lblTitle.text = "Cập nhật bài viết"
        }
        
        self.tblCategory.isHidden = true
        btnCategoryOutlet.layer.borderWidth = 1
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblCategory.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)
        cell.textLabel?.text = categorys[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tblCategory.cellForRow(at: indexPath)
        btnCategoryOutlet.setTitle(cell?.textLabel?.text, for: .normal)
        self.tblCategory.isHidden = true
    }
    
    @IBAction func btnCategory(_ sender: Any) {
        self.tblCategory.isHidden = !self.tblCategory.isHidden
    }
    
    @IBAction func btnSelectPhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    
    @IBAction func btnSave(_ sender: UIButton) {
        
        var avatar: String = ""
        
        if let image = imgAvatar.image {
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                avatar = imageData.base64EncodedString()
            }
        }
        
        let title = txtTitlePosts.text ?? ""
        let content = txtContent.text ?? ""
        let category = btnCategoryOutlet.titleLabel?.text ?? ""
        
        if title != "" && content != "" && category != "Chọn thể loại" {
            if let user = UserDefaults.standard.dictionary(forKey: "user") {
                let idUser = user["idUser"]
                let posts = PostsModel(id: self.posts.id, idUser: idUser as! Int, avatar: "\(avatar)", title: "\(title)", content: "\(content)", category: "\(category)")
                if posts.id == 0 {
                    APIHandler.init().insertPosts(_posts: posts) { success in
                        if success {
                            
                            let alert = UIAlertController(title: "Thành công", message: "Bài viết đã được lưu.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default) { action in
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    APIHandler.init().updatePosts(id: self.posts.id, _posts: posts) { success in
                        if success {
                            let alert = UIAlertController(title: "Thành công", message: "Bài viết đã được cập nhật", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default) { action in
                            }
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }
        txtTitlePosts.text = ""
        txtContent.text = ""
        btnCategoryOutlet.setTitle("Chọn thể loại", for: .normal)
    }
    
    
    @IBAction func btnCancel(_ sender: UIButton) {
        imgAvatar.image = nil
        txtTitlePosts.text = ""
        txtContent.text = ""
        btnCategoryOutlet.setTitle("Chọn thể loại", for: .normal)
    }
}

extension InsertOrUpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imgAvatar.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

