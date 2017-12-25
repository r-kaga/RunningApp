
import UIKit

class PageMenuButton: UIView {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var grahButton: UIButton!
    
    private var selectedView: UIView!

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
        
        let view = Bundle.main.loadNibNamed("PageMenuButton", owner: self, options: nil)?.first as! UIView
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
        
        selectedView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2 - 50, height: 25))
        selectedView.center = CGPoint(x: self.frame.width / 4, y: 20)
        selectedView.alpha = 0.7
        selectedView.layer.cornerRadius = 5.0
        selectedView.clipsToBounds = true
        selectedView.backgroundColor = .white
        self.addSubview(selectedView)
    }
    
    
    public func didSelect(index: Int) {
        switch index {
            case 0:
                UIView.animate(withDuration: 0.5, animations: {
                    self.selectedView.center = CGPoint(x: self.frame.width / 4, y: self.selectedView.frame.midY)
                })
            case 1:
                UIView.animate(withDuration: 0.5, animations: {
                    self.selectedView.center = CGPoint(x: self.frame.width - (self.frame.width / 4), y: self.selectedView.frame.midY)
                })
            default: break
        }
    }
    
}
