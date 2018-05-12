
import Foundation
import UIKit

protocol BaseUIButton where Self:UIButton {
    var cornerRadius: CGFloat { get }
    var isRound: Bool{ get }
    var borderColor: UIColor { get }
    var borderWidth: CGFloat { get }
}

extension BaseUIButton where Self:UIButton {
    
    var cornerRadius: CGFloat {
        return 5.0
    }
    
    var isRound: Bool {
        return false
    }
    
    var borderColor: UIColor {
        return .lightGray
    }
    
    var borderWidth: CGFloat {
        return 0.3
    }

}

@IBDesignable
class BaseButton: UIButton, BaseUIButton {
    
    @IBInspectable var cornerRadius: CGFloat {
        return 5.0
    }
    
    @IBInspectable var isRound: Bool {
        return false
    }
    
    @IBInspectable var borderColor: UIColor {
        return .lightGray
    }
    
    @IBInspectable var borderWidth: CGFloat {
        return 0.3
    }
    
}
