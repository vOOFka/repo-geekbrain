//
//  NetworkService.swift
//  vkontakteVS
//
//  Created by Home on 27.08.2021.
//

import UIKit
import Alamofire

class NetworkService {
    private let host = "https://api.vk.com/method/"
    private let userId = UserSession.shared.userId
    private let accessToken = UserSession.shared.token
    private let versionAPI = "5.131"
    
    let session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        return Session(configuration: config)
    }()
    
    private func decodingData<T:Decodable> (type: T.Type, from data: Data?) -> T? {
        guard let data = data,
              let decoded = try? JSONDecoder().decode(type.self, from: data) else { return nil }
        return decoded
    }
    
    func getNewsfeed(completion: @escaping (NewsFeed?) -> Void) {
        let path = "newsfeed.get"
        let parameters: Parameters = ["user_id" : userId,
                                      "access_token" : accessToken,
                                      "v" : versionAPI,
                                      "filters" : "post,photo,photo_tag,wall_photo",
                                      "count": "10"]
        session.request(host + path, method: .get, parameters: parameters).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                completion(self.decodingData(type: NewsFeed.self, from: data))
            }
        }
    }
    
    func getGroups(completion: @escaping (Groups?) -> Void) {
        let path = "groups.get"
        let parameters: Parameters = ["user_id" : userId,
                                      "access_token" : accessToken,
                                      "v" : versionAPI,
                                      "extended" : "1"]
        session.request(host + path, method: .get, parameters: parameters).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                completion(self.decodingData(type: Groups.self, from: data))
            }
        }
    }
    
    func searchGroups(search groupeName: String, completion: @escaping (Groups?) -> Void) {
        let path = "groups.search"
        let parameters: Parameters = ["q" : groupeName,
                                      "count" : "20",
                                      "user_id" : userId,
                                      "access_token" : accessToken,
                                      "v" : versionAPI,
                                      "extended" : "1",
                                      "type" : "group"]
        session.request(host + path, method: .get, parameters: parameters).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                completion(self.decodingData(type: Groups.self, from: data))
            }
        }
    }
    
    func getFriends(completion: @escaping (Friends?) -> Void) {
        let path = "friends.get"
        let parameters: Parameters = ["user_id" : userId,
                                      "access_token" : accessToken,
                                      "v" : versionAPI,
                                      "fields" : "nickname, domain, sex, bdate, city, photo_100"]
        session.request(host + path, method: .get, parameters: parameters).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                completion(self.decodingData(type: Friends.self, from: data))
            }
        }
    }
    
    func getPhotosAll(friendId: Int, completion: @escaping (Photos?) -> Void) {
        let path = "photos.getAll"
        let parameters: Parameters = ["owner_id" : friendId,
                                      "access_token" : accessToken,
                                      "v" : versionAPI,
                                      "extended" : "1"]
        session.request(host + path, method: .get, parameters: parameters).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                completion(self.decodingData(type: Photos.self, from: data))
            }
        }
    }
    
    func getImageFromWeb(imageURL: String, completion: @escaping (UIImage) -> Void) {
        Alamofire.AF.request(imageURL, method: .get).response { (response) in
            if response.error == nil {
                print(response.result)
                if let data = response.data {
                    completion(UIImage(data: data)!)
                } else {
                    completion(UIImage(named: "NoImage")!)
                }
            }
        }
    }
}
