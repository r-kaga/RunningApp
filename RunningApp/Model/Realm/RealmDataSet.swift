

import Foundation
import RealmSwift

class RealmDataSet: Object {
    
//    var maxId: Int {
//        return try! Realm().objects(type(of: self).self).sorted(byKeyPath: "id").last?.id ?? 0
//    }
    
    static let shared = RealmDataSet()
    static let realm = try! Realm()

    
    var getNewId: Int {
        let maxId = RealmDataSet.realm.objects(type(of: self).self).sorted(byKeyPath: "id").last?.id ?? 0
        return maxId + 1
    }

    
    func getAllData(ascending: Bool = false) -> Results<RealmDataSet> {
        return RealmDataSet.realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: ascending)
    }
    
    @objc dynamic var id       = 1 // PrimartKey
    @objc dynamic var date     = String()
    @objc dynamic var distance = String()
    @objc dynamic var speed    = String()
    @objc dynamic var calorie  = String()
    @objc dynamic var time     = String()
    @objc dynamic var workType = String()
    @objc dynamic var minAlt   = String()
    @objc dynamic var maxAlt   = String()
    @objc dynamic var pausedTime   = String()

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





