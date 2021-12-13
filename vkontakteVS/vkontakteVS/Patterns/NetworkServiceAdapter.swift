//
//  NetworkServiceAdapter.swift
//  vkontakteVS
//
//  Created by Home on 13.12.2021.
//

import RealmSwift
import UIKit

final class NetworkServiceAdapter {
    
    private let networkService = NetworkServiceImplimentation()
    private var realmNotificationTokens: [String: NotificationToken] = [:]
    
    func getFriends(completion: @escaping ([FriendViewModel]) -> Void) {
        guard
            let realm = try? Realm()
        else { return }
        let realmFriends = realm.objects(RealmFriend.self)
        let token = realmFriends.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            switch changes {
            case .update(let realmFriends, _, _, _):
                var friends: [FriendViewModel] = []
                for item in realmFriends {
                    friends.append(self.friendViewModel(from: item))
                }
                completion(friends)
            case .error(let error):
                fatalError("\(error)")
            case .initial:
                break
            }
        }
        //self.realmNotificationTokens[city] = token
        //weatherService.loadWeatherData(city: city)
    }
    
    private func friendViewModel(from rlmFriend: RealmFriend) -> FriendViewModel {
        return FriendViewModel(id: rlmFriend.id,
                               fullName: rlmFriend.fullName,
                               category: rlmFriend.category,
                               cityName: rlmFriend.cityName,
                               urlAvatar: rlmFriend.urlAvatar,
                               imageAvatar: nil)
    }
}
