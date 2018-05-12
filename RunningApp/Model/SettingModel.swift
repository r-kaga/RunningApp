

import Foundation
import UIKit

protocol SettingModelProtocol {

}

class SettingModel: SettingModelProtocol {
    


    
}

enum headerItem: String {
    case selfMonitoring = "self monitoring"
    static var count = 1
}

/* 設定項目
 */
enum SettingType: Int {
    case weight     = 0
    case height
    case pushTime
    case pace
    
    static let count: Int = {
        var i = 0
        while let _ = SettingType(rawValue: i) {
            i = i + 1
        }
        return i
    }()
}


enum tableItem {
    static func getTableItem(indexPath: Int) -> (String?, String?, String, UIImage?) {
        switch indexPath {
        case 0:
            return (tableItem.weight.type, tableItem.weight.descriptino, tableItem.weight.unit, tableItem.weight.image)
        case 1:
            return (tableItem.height.type, tableItem.height.descriptino, tableItem.height.unit, tableItem.height.image)
        case 2:
            return (tableItem.pushTime.type, tableItem.pushTime.descriptino, tableItem.pushTime.unit, tableItem.pushTime.image)
            
        case 3:
            return (tableItem.pace.type, tableItem.pace.descriptino, tableItem.pace.unit, tableItem.pace.image)
            
        default:
            return (tableItem.weight.type, tableItem.weight.descriptino, tableItem.weight.unit, tableItem.weight.image)
        }
    }
    
    enum weight {
        static var type: String {
            return "weight"
        }
        static var unit: String {
            return "Kg"
        }
        
        static var descriptino: String {
            return "カロリー計算で使用します"
        }
        
        static var image: UIImage {
            return UIImage(named: "assignment")!
        }
    }
    enum height {
        static var type: String {
            return "height"
        }
        static var unit: String {
            return "cm"
        }
        
        static var descriptino: String {
            return "カロリー計算で使用します"
        }
        
        static var image: UIImage {
            return UIImage(named: "assignment")!
        }
        
    }
    enum pushTime {
        static var type: String {
            return Const.PUSH_TIME
        }
        static var unit: String {
            return "時"
        }
        static var descriptino: String {
            return "指定した時間にリマインドします"
        }
        
        static var image: UIImage {
            return UIImage(named: "pushTime")!
        }
        
    }
    enum pace {
        static var type: String {
            return "pace"
        }
        static var unit: String {
            return "Km/h"
        }
        static var descriptino: String {
            return "理想のペースを設定します"
        }
        
        static var image: UIImage {
            return UIImage(named: "pushTime")!
        }
        
    }
    
}
