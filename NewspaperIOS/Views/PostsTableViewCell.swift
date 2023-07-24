//
//  PostsTableViewCell.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgAvatarPosts: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
