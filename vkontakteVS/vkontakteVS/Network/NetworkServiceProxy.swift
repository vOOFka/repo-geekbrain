//
//  NetworkServiceProxy.swift
//  vkontakteVS
//
//  Created by Home on 22.12.2021.
//

import Foundation
import PromiseKit
import Alamofire

class NetworkServiceProxy: NetworkService {
    let networkService: NetworkServiceImplimentation
    
    init(networkService: NetworkServiceImplimentation) {
        self.networkService = networkService
    }
    
    func getNewsfeed(completion: @escaping (NewsFeed?) -> Void) {
        print("Log 👮🏼‍♂️, get news from web.")
        return self.networkService.getNewsfeed(completion: completion)
    }
    
    func getGroups(completion: @escaping (Groups?) -> Void) {
        print("Log 👮🏼‍♂️, get groups from web.")
        return self.networkService.getGroups(completion: completion)
    }
    
    func searchGroups(search groupeName: String, completion: @escaping (Groups?) -> Void) {
        print("Log 👮🏼‍♂️, search groups in web.")
        self.networkService.searchGroups(search: groupeName, completion: completion)
    }
    
    func getFriends(completion: @escaping (Friends?) -> Void) {
        print("Log 👮🏼‍♂️, get friends from web.")
        self.networkService.getFriends(completion: completion)
    }
    
    func getPhotosAll(friendId: Int, completion: @escaping (Photos?) -> Void) {
        print("Log 👮🏼‍♂️, get all photos from web.")
        self.networkService.getPhotosAll(friendId: friendId, completion: completion)
    }
    
    func decodingData<T>(type: T.Type, from data: Data?) -> T? where T : Decodable {
        print("Log 👮🏼‍♂️, decoding Data")
        return self.decodingData(type: type, from: data)
    }
    
    func getFriendsRequest() -> DataRequest {
        print("Log 👮🏼‍♂️, friends request from web.")
        return self.networkService.getFriendsRequest()
    }
    
    func getGroups() -> Promise<Data> {
        print("Log 👮🏼‍♂️, get Groups from web.")
        return self.networkService.getGroups()
    }
    
    func getParsingGroups(_ data: Data) -> Promise<Groups> {
        print("Log 👮🏼‍♂️, parsing Groups.")
        return self.networkService.getParsingGroups(data)
    }
    
    func getNewsfeedRequest(_ timeInterval1970: String?, nextFrom: String) -> DataRequest {
        print("Log 👮🏼‍♂️, get news from web")
        return self.networkService.getNewsfeedRequest(timeInterval1970, nextFrom: nextFrom)
    }
    
    func loadFriends() {
        print("Log 👮🏼‍♂️, load friends.")
        self.networkService.loadFriends()
    }
    
    func getImageFromWeb(imageURL: String, completion: @escaping (Data) -> Void) {
        print("Log 👮🏼‍♂️, get image from web.")
        self.networkService.getImageFromWeb(imageURL: imageURL, completion: completion)
    }
}
