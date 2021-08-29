//
//  NetworkService.swift
//  vkontakteVS
//
//  Created by Home on 27.08.2021.
//

import Foundation
import Alamofire

class NetworkService {
    private let host = "https://api.vk.com/"
    
    let session: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        return Session(configuration: config)
    }()

    func getGroups() {
        let path = "method/groups.get"
        let parameters: Parameters = ["user_id" : UserSession.shared.userId,
                                    "access_token" : UserSession.shared.token,
                                    "v" : "5.131",
                                    "extended" : "1"]
        let requestAF = session.request(host + path, method: .get, parameters: parameters)
        requestAF.responseJSON { response in print(response.value ?? "No groups") }
    }
    
    func searchGroups(search groupeName: String) {
        let path = "method/groups.search"
        let parameters: Parameters = ["q" : groupeName,
                                    "count" : "3",
                                    "user_id" : UserSession.shared.userId,
                                    "access_token" : UserSession.shared.token,
                                    "v" : "5.131",
                                    "extended" : "1"]
        let requestAF = session.request(host + path, method: .get, parameters: parameters)
        requestAF.responseJSON { response in print(response.value ?? "No groups finds") }
    }
    
    func getFriends() {
        let path = "method/friends.get"
        let parameters: Parameters = ["user_id" : UserSession.shared.userId,
                                    "access_token" : UserSession.shared.token,
                                    "v" : "5.131",
                                    "fields" : "nickname, domain, sex, bdate, city",
                                    "order" : "name"]
        let requestAF = session.request(host + path, method: .get, parameters: parameters)
        requestAF.responseJSON { response in print(response.value ?? "No friends finds") }
    }
    
    func getPhotos(friendId: String) {
        let path = "method/photos.get"
        let parameters: Parameters = ["owner_id" : friendId,
                                    "access_token" : UserSession.shared.token,
                                    "v" : "5.131",
                                    "album_id" : "wall",
                                    "extended" : "1"]
        let requestAF = session.request(host + path, method: .get, parameters: parameters)
        requestAF.responseJSON { response in print(response.value ?? "No photo finds") }
    }
}
