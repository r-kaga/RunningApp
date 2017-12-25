

import Foundation
import UIKit


extension UIViewController {

    /** 長押しされたら、震えるようなアニメーション */
    @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
        let view = sender.view as! resultView
        view.touchStartAnimation()
        view.deleteButton.isHidden = false
        view.indexPath = sender.view?.tag
 
        view.Vibrate()
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        sender.view?.touchEndAnimation()
        
        let view = sender.view as! resultView
        view.deleteButton.isHidden = true
        view.deleteButton.alpha = 1
        
        view.layer.removeAllAnimations()
    }
    
    
    func refresh() {
        self.loadView()
        self.viewDidLoad()
    }
    
    
}
