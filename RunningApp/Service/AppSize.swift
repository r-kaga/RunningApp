

import Foundation
import UIKit

struct AppSize {
    
    static let bounds = UIScreen.main.bounds

    static let height = UIScreen.main.bounds.size.height
    
    static let width = UIScreen.main.bounds.size.width
    
    static let center = CGPoint(x: AppSize.width / 2, y: AppSize.height / 2)
    
    static var tabBarHeight: CGFloat { return 49 }
    
    static var toolBarHeight: CGFloat { return 44 }

    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    static var navigationBarHeight: CGFloat { return 44 }
 
    static var statusBarAndNavigationBarHeight: CGFloat { return statusBarHeight + navigationBarHeight }
    
    static var backgroundColor: UIColor {
        return UIColor(red: 242/256, green: 242/256, blue: 242/256, alpha: 1.0)
    }
    
    static var navigationAndTabBarColor: UIColor {
//        return UIColor(red: 0/255, green: 158/255, blue: 254/255, alpha: 1.0)
//        return UIColor(red: 60/255, green: 169/255, blue: 232/255, alpha: 1.0)
//        return UIColor(red: 64/255, green: 161/255, blue: 247/255, alpha: 1.0)
        return UIColor(red: 55/255, green: 95/255, blue: 200/255, alpha: 1.0)
    }

    
    
}
