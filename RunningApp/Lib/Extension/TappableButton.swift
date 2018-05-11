
import Foundation
import UIKit


class TappableButton: UIButton, BaseUIButton {
    
    override func draw(_ rect: CGRect) {

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
