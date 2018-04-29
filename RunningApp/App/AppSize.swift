

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
  
    
}
