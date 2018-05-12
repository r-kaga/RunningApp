

import UIKit
import Lottie

class RunManageCardView: UIView {
    
    private var animationName: String {
        return "animation" + String(arc4random_uniform(3) + 1)
    }

    @IBOutlet weak var endButton: TappableButton!
    @IBOutlet weak var animationView: LOTAnimationView! {
        didSet {
            animationView.setAnimation(named: animationName)
            animationView.loopAnimation = true
            animationView.contentMode = .scaleAspectFit
            animationView.animationSpeed = 1
//            animationView.play()
        }
    }
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!

    /** イニシャライザー */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        self.loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
        self.loadFromNib()
    }

    /** Nibファイル読み込み */
    private func loadFromNib() {
        let view = Bundle.main.loadNibNamed("RunManageCardView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        self.addSubview(view)
        
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
    }
    
    private func setupLayout() {
        layer.cornerRadius = 10.0
        clipsToBounds = true
    }

}
