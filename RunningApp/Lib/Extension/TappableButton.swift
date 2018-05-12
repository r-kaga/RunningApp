
import Foundation
import UIKit


@IBDesignable
class TappableButton: UIButton, BaseUIButton {
    
    override func draw(_ rect: CGRect) {
        clipsToBounds = true
        if isRound {
            layer.cornerRadius = frame.width / 2
        } else {
            layer.cornerRadius = cornerRadius
        }
        
        if isBorder {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }

    }
    
    @IBInspectable var cornerRadius: CGFloat {
        return 5.0
    }
    
    @IBInspectable var isRound: Bool {
        return false
    }
    
    @IBInspectable var isBorder: Bool {
        return false
    }

    @IBInspectable var borderColor: UIColor {
        return .lightGray
    }
    
    @IBInspectable var borderWidth: CGFloat {
        return 0.3
    }
    
    private var alphaBefore: CGFloat = 1
    private var selectedAlpha: CGFloat = 0.6
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alphaBefore = alpha
        UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = self.selectedAlpha
        })
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.35, delay: 0, options: .allowUserInteraction, animations: {
            self.alpha = self.alphaBefore
        })
    }
    
}
