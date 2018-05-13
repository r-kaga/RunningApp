
import Foundation
import UIKit
import UserNotifications


protocol Notify: class {
    var notificationName: Notification.Name { get }
    func addObserver(_ observer: Any, selector: Selector)
    func removeObserver(_ observer: Any)
    func notify()
}

extension Notify {
    
    var notificationName: Notification.Name {
        return Notification.Name(rawValue: "\(type(of: self))")
    }
    
    func notify() {
        print("Notify + \(type(of: Self.self))")
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    func addObserver(_ observer: Any, selector: Selector) {
        print("addObserver + \(type(of: Self.self))")
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName, object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        print("removeObserver + \(type(of: Self.self))")
        NotificationCenter.default.removeObserver(observer)
    }
    
}
