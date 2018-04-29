
import Foundation

protocol HomeModelNotify: class {
    var notificationName: Notification.Name { get }
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
    func notify()
}

protocol HomeModelProtocol: HomeModelNotify {
//    init()
    func didFinishRunning()
}

class HomeModel: HomeModelProtocol {
    
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

extension HomeModel {
    
}
