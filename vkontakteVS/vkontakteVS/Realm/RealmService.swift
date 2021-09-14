//
//  RealmService.swift
//  vkontakteVS
//
//  Created by Home on 13.09.2021.
//

import RealmSwift

protocol RealmService {
    func save<T: Object>(_ items: [T]) throws -> Realm
    func get<T: Object, KeyType> (_ type: T.Type, primaryKey: KeyType) throws -> T?
    func get<T: Object> (_ type: T.Type) throws -> Results<T>
}

class RealmServiceImplimentation: RealmService {
    func save<T: Object>(_ items: [T]) throws -> Realm {
        let realm = try Realm(configuration: .defaultConfiguration)
        realm.beginWrite()
        realm.add(items)
        try realm.commitWrite()
        return realm
    }
    
    func get<T: Object, KeyType> (_ type: T.Type, primaryKey: KeyType) throws -> T? {
        let realm = try Realm()
        return realm.object(ofType: type, forPrimaryKey: primaryKey)
    }
    
    func get<T: Object> (_ type: T.Type) throws -> Results<T> {
        let realm = try Realm()
        return realm.objects(type)
    }
}
