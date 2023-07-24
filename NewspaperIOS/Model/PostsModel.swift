//
//  PostsModel.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import Foundation

struct PostsModel: Codable {
    var id: Int
    var idUser: Int
    var avatar: String
    var title: String
    var content: String
    var category: String

    init(id: Int, idUser: Int, avatar: String, title: String, content: String, category: String) {
        self.id = id
        self.idUser = idUser
        self.avatar = avatar
        self.title = title
        self.content = content
        self.category = category
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idUser = "idUser"
        case avatar = "avatar"
        case title = "title"
        case content = "content"
        case category = "category"
    }
    
}




typealias Posts = [PostsModel]

