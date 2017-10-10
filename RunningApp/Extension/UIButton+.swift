
import Foundation
import UIKit

class SettingButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
}
