//
//  RealmDataSet.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/18.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataSet: Object {
    
//    var maxId: Int {
//        return try! Realm().objects(type(of: self).self).sorted(byKeyPath: "id").last?.id ?? 0
//    }
    
    @objc dynamic var id       = 1 // PrimartKey
    @objc dynamic var date     = String()
    @objc dynamic var distance = String()
    @objc dynamic var speed    = String()
    @objc dynamic var calorie  = String()
    @objc dynamic var time     = String()
    
    
//    func save() {
//        let realm = try! Realm()
//        if realm.isInWriteTransaction {
//            if self.id == 0 {
//                self.id = self.createNewId()
//            }
//            realm.add(self, update: true)
//        } else {
//            try! realm.write {
//                if self.id == 0 {
//                    self.id = self.createNewId()
//                    realm.add(self, update: true)
//                }
//            }
//        }
//    }
    
    
//    // 新しいIDを採番します。
//    func createNewId() -> Int {
//        let realm = try! Realm()
//        return (realm.objects(type(of: self).self).sorted(byKeyPath: "id", ascending: false).first?.id ?? 0) + 1
//    }
    
    
    // プライマリーキーの設定
    override static func primaryKey() -> String? {
        return "id"
    }

    
}





//struct RealmModel {
//    struct realmModel {
//
//        static var realmTry = try! Realm()
//
//        static var realmSet = RealmDataSet()
//
//        static var realmSet: RealmDataSet {
//            let realm = RealmDataSet()
//            realm.id = realm.createNewId(realm: realmModel.realmTry)
//            return realm
//        }
//
//        static var usersSet = realmModel.realmTry.objects(RealmDataSet.self)
//    }
//
//}





