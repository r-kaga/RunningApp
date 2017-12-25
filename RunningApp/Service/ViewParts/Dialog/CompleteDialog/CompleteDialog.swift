

import Foundation
import UIKit

class CompleteDialog: UIView, DialogProtocol {

    @IBOutlet weak var completeImageView: UIView!
    
    /** ビュー作成
     * @return Parts
     */
    class func make() -> CompleteDialog? {
        let view = UINib(nibName: "CompleteDialog", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! CompleteDialog
        view.tag = 99
        
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.completeImageView.layer.borderColor = UIColor.white.cgColor
        self.completeImageView.layer.borderWidth = 2.0
        self.completeImageView.layer.cornerRadius = 15.0
        self.completeImageView.clipsToBounds = true

        //　斜めの状態の画像を作る
        // radianで回転角度を指定(35度).
        let angle = -15 * CGFloat.pi / 180
        self.completeImageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }
    
//    override func didMoveToWindow() {
//        self.doStamp()
//    }
    
    /** 表示
     */
    func open() {
        let app = UIApplication.shared.delegate as! AppDelegate
        self.frame = (app.window?.frame)!
        
        self.completeImageView.isHidden = true

        app.window?.addSubview(self)
 
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.stamp()
        })
    }
    
    
    func stamp() {
        self.completeImageView.alpha = 0
        self.completeImageView.isHidden = false

        UIView.animate(withDuration: 0.05,
                       delay: 0.0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                       options:[],
                       animations:{

                        // サイズを大きくする
//                        self.completeImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)

        UIView.animate(withDuration: 0.05,
                       delay: 0.1,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 90,
                       options: [], animations: {
//                        // サイズを元に戻す
//                        self.completeImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        // 透過度を元に戻す
                        self.completeImageView.alpha = 1.0
        }, completion:{ finished in
            // 台紙を揺らす
            self.vibrate(amount: 3.0)
        })
        
    }
    
    /** タッチイベント
     * @param touches -
     * @param event -
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.close()
    }

    
}


