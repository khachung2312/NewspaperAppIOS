//
//  UserModel.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 20/07/2023.
//

import Foundation

struct UserModel: Codable {
    var idUser: Int
    var username: String
    var fullname: String
    var email: String
    var phone: String
    var password: String
    
    init(idUser: Int,username: String, fullname: String, email: String, phone: String, password: String) {
        self.idUser = idUser
        self.username = username
        self.fullname = fullname
        self.email = email
        self.phone = phone
        self.password = password
    }
}
typealias User = [UserModel]
