//
//  NetworkService.swift
//  vkontakteVS
//
//  Created by Home on 27.08.2021.
//

import Foundation
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
    
    func getGroups() {
        let path = "groups.get"
        let parameters: Parameters = ["user_id" : userId,
                                    "access_token" : accessToken,
                                    "v" : versionAPI,
                                    "extended" : "1"]
        let requestAF = session.request(host + path, method: .get, parameters: parameters)
        requestAF.responseJSON { response in
        }
    }
    
    func searchGroups(search groupeName: String) {
        let path = "groups.search"
        let parameters: Parameters = ["q" : groupeName,
                                    "count" : "3",
                                    "user_id" : userId,
                                    "access_token" : accessToken,
                                    "v" : versionAPI,
                                    "extended" : "1"]
        let requestAF = session.request(host + path, method: .get, parameters: parameters)
        requestAF.responseJSON { response in print(response.value ?? "No groups finds") }
    }
    
    func getFriends(completion: @escaping (Friends?) -> Void) {
        let path = "friends.get"
        let parameters: Parameters = ["user_id" : userId,
                                    "access_token" : accessToken,
                                    "v" : versionAPI,
                                    "fields" : "nickname, domain, sex, bdate, city"]
        session.request(host + path, method: .get, parameters: parameters).response { response in
            switch response.result {
            case .failure(let error):
                print(error)
            case .success(let data):
                completion(self.decodingData(type: Friends.self, from: data))
            }
        }
    }
    
    func getPhotos(friendId: String) {
        let path = "photos.get"
        let parameters: Parameters = ["owner_id" : friendId,
                                    "access_token" : accessToken,
                                    "v" : versionAPI,
                                    "album_id" : "wall",
                                    "extended" : "1"]
        let requestAF = session.request(host + path, method: .get, parameters: parameters)
        requestAF.responseJSON { response in print(response.value ?? "No photo finds") }
    }
}
