
import Foundation
import RealmSwift

protocol HomeModelNotify: class {
    var notificationName: Notification.Name { get }
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
    func notify()
}

protocol HomeModelProtocol: HomeModelNotify {
    func didFinishRunning()
    var latestData: Results<RealmDataSet> { get }
}

class HomeModel: HomeModelProtocol {
    
    var latestData: Results<RealmDataSet> {
        return RealmDataSet.getAllData()
    }
    
    var notificationName: Notification.Name {
        return Notification.Name("Home")
    }
    
    func notify() {
        print("notify")
    }
    
    func addObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    func didFinishRunning() {
        print("didFinishRunning")
    }
    
    
}
