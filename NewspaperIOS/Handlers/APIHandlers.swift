//
//  APIHandlers.swift
//  NewspaperIOS
//
//  Created by Khắc Hùng on 18/07/2023.
//

import Foundation
import Alamofire

class APIHandler {
    
    let BASE_GET_POSTS_URL = "http://192.168.1.5:8080/posts"
    let BASE_SEARCH_POSTS = "http://192.168.1.5:8080/posts/search"
    let BASE_REGISTER_ACCOUNT = "http://192.168.1.5:8080/users/register"
    let BASE_LOGIN_ACCOUNT = "http://192.168.1.5:8080/users/login"
    let BASE_GET_ALLPOSTS_BY_ID_USER = "http://192.168.1.5:8080/posts/getAllPostsById"
    
    func getPosts (completion: @escaping (Posts) -> ()) {
        AF.request("\(BASE_GET_POSTS_URL)", method: .get).responseDecodable(of: Posts.self){
            (respone) in
            if let postsResponse = respone.value {
                completion(postsResponse)
            }
        }
    }
    
    func getAllPostsByIdUser(completion: @escaping (Posts) -> ()) {
        if let user = UserDefaults.standard.dictionary(forKey: "user") {
            let idUser = user["idUser"] as! Int
            let url = "\(BASE_GET_ALLPOSTS_BY_ID_USER)"
            let parameters: [String: Any] = ["idUser": idUser]
            AF.request(url, method: .post, parameters: parameters).responseDecodable(of: Posts.self) { response in
                if let postsResponse = response.value {
                    completion(postsResponse)
                }
            }
        }
    }
    
    
    func insertPosts(_posts: PostsModel, completion: @escaping (Bool) -> ()) {
        let parameters: [String: Any] = [
            "idUser": _posts.idUser,
            "avatar": _posts.avatar,
            "title": _posts.title,
            "content": _posts.content,
            "category": _posts.category
        ]
        AF.request(BASE_GET_POSTS_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            if response.error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    func updatePosts(id: Int, _posts: PostsModel, completion: @escaping (Bool) -> ()) {
        let parameters: [String: Any] = [
            "avatar": _posts.avatar,
            "title": _posts.title,
            "content": _posts.content,
            "category": _posts.category
        ]
        let url = "\(BASE_GET_POSTS_URL)/\(id)"
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default).response { response in
            if response.error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func searchPosts(category: String, completion: @escaping (Posts) -> ()) {
        let parameters: [String: Any] = [
            "category": category
        ]
        AF.request(BASE_SEARCH_POSTS, method: .get, parameters: parameters).responseDecodable(of: Posts.self){
            (response) in
            if let postsResponse = response.value {
                completion(postsResponse)
            }
        }
    }
    
    
    func deletePost(id: Int, completion: @escaping (Bool) -> ()) {
        let url = "\(BASE_GET_POSTS_URL)/\(id)"
        AF.request(url, method: .delete).response { response in
            if response.error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func registerUser(username: String, fullname: String, email: String, phone: String, password: String, completion: @escaping (Bool) -> ()) {
        let parameters: [String: Any] = [
            "username": username,
            "fullname": fullname,
            "email": email,
            "phone": phone,
            "password": password
        ]
        AF.request("\(BASE_REGISTER_ACCOUNT)", method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
            if response.error == nil {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func loginUser(username: String, password: String, completion: @escaping (Bool, [String: Any]?) -> ()) {
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        AF.request("\(BASE_LOGIN_ACCOUNT)", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let userJson = json as? [String: Any] {
                    completion(true, userJson)
                } else {
                    completion(false, nil)
                }
            case .failure(let error):
                print("Đăng nhập thất bại: \(error)")
                completion(false, nil)
            }
        }
    }
}
