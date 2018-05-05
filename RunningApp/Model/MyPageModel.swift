
import Foundation
import RealmSwift

protocol MyPageModelNotify: class {
    var notificationName: Notification.Name { get }
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
    func notify()
}

protocol MyPageModelProtocol: MyPageModelNotify {
    var myInfo: Results<RealmDataSet> { get }
}

class MyPageModel: MyPageModelProtocol {
    
    lazy var myInfo: Results<RealmDataSet> = {
        return RealmDataSet.getAllData()
    }()
    
    var notificationName: Notification.Name {
        return Notification.Name("MyPage")
    }
    
    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func notify() {
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    
}
