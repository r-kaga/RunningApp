

import Foundation
import UIKit


class RoundButton: UIView {
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var firstRoundButton: UIButton!
    @IBOutlet weak var secondRoundButton: UIButton!
    @IBOutlet weak var thirdRoundButton: UIButton!
    
    var firstRoundButtonCenter: CGPoint!
    var secondRoundButtonCenter: CGPoint!
    var thirdRoundButtonCenter: CGPoint!

    var isOpen: Bool = false
    
    @IBAction func moreButtonAction(_ sender: Any) {
        //        if sender.currentImage == {
        //
        //        } else {
        //
        //        }
        
        if isOpen {

            UIView.animate(withDuration: 0.3, animations: {
                
                self.firstRoundButton.center = self.moreButton.center
                self.secondRoundButton.center = self.moreButton.center
                self.thirdRoundButton.center = self.moreButton.center
                
                self.firstRoundButton.alpha = 0.0
                self.secondRoundButton.alpha = 0.0
                self.thirdRoundButton.alpha = 0.0
            })
            
            isOpen = false
            
        } else {

            self.firstRoundButton.center = self.moreButton.center
            self.secondRoundButton.center = self.moreButton.center
            self.thirdRoundButton.center = self.moreButton.center
            
            UIView.animate(withDuration: 0.3) {
                
                self.firstRoundButton.alpha = 1.0
                self.secondRoundButton.alpha = 1.0
                self.thirdRoundButton.alpha = 1.0
                
                self.firstRoundButton.center = self.firstRoundButtonCenter
                self.secondRoundButton.center = self.secondRoundButtonCenter
                self.thirdRoundButton.center = self.thirdRoundButtonCenter
            }
            
            isOpen = true

        }
        

    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        self.firstRoundButtonCenter = self.firstRoundButton.center
        self.secondRoundButtonCenter = self.secondRoundButton.center
        self.thirdRoundButtonCenter = self.thirdRoundButton.center
    }
    
 
    /** イニシャライザー */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
    }
    
    
    /** Nibファイル読み込み */
    private func loadFromNib() {
        
        let view = Bundle.main.loadNibNamed("RoundButton", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        self.addSubview(view)
        
        self.firstRoundButtonCenter = self.firstRoundButton.center
        self.secondRoundButtonCenter = self.secondRoundButton.center
        self.thirdRoundButtonCenter = self.thirdRoundButton.center
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints1 = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[view]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["view" : view]
        )
        self.addConstraints(constraints1)
        
        let constraints2 = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[view]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["view" : view]
        )
        self.addConstraints(constraints2)

        
        self.firstRoundButton.alpha = 0.0
        self.secondRoundButton.alpha = 0.0
        self.thirdRoundButton.alpha = 0.0
        
        self.moreButton.layer.cornerRadius = self.moreButton.frame.width / 2
        self.firstRoundButton.layer.cornerRadius = self.firstRoundButton.frame.width / 2
        self.secondRoundButton.layer.cornerRadius = self.secondRoundButton.frame.width / 2
        self.thirdRoundButton.layer.cornerRadius = self.thirdRoundButton.frame.width / 2
        
        self.moreButton.clipsToBounds = true
        self.firstRoundButton.clipsToBounds = true
        self.secondRoundButton.clipsToBounds = true
        self.thirdRoundButton.clipsToBounds = true
        
    }

    
}





