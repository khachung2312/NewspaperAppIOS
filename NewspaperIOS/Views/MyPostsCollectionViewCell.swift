//
//  MyPostsCollectionViewCell.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit

class MyPostsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatarPosts: UIImageView!
    var onDelete: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnDelete(_ sender: UIButton) {
        let alert = UIAlertController(title: "Xoá bài viết", message: "Bạn có muốn xoá bài viết không?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Xoá", style: .destructive, handler: { action in
            self.onDelete?()
        }))
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
