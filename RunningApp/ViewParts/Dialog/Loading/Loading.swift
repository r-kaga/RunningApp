//
//  Loading.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/11/02.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit

class Loading: UIView, DialogProtocol {

//    static let PROGRESS_LINE_COLOR = UIColor.red // プログレスバーカラー
//    static let BASE_LINE_COLOR = UIColor.lightGray // ラインバックグランドカラー
    static let CIRCLE_RATE: CGFloat = 80 // メインのビューのサイズから何パーセンの大きさにするか
    
    @IBOutlet weak var panelOutlet: UIView!
    
    var progress_layer: CAShapeLayer!
    var fix_rect: CGRect!
    var time: CGFloat!
    var timer: Timer?
    
    var workItem: DispatchWorkItem?
    
    /** ビュー作成
     * @return Parts
     */
    class func make() -> Loading? {
        let _ = Dialog.removeAllSuperview()
        
        let view = UINib(nibName: "Loading", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! Loading
        view.tag = 88
        return view
    }
    
    
    /** outlet等がインスタンス化された後に呼ばれる */
    override func awakeFromNib() {
        initSetUp()
        appearance()
    }
    
    /** コンストラクタ
     * @param aDecoder -
     */
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    /** 初期設定 */
    private func initSetUp() {
    }
    
    /** 表示装飾系セットアップ */
    private func appearance() {

        self.panelOutlet.isHidden = true
        self.panelOutlet.layer.cornerRadius = 15.0
//        self.panelOutlet.layer.cornerRadius = self.panelOutlet.frame.width / 2
//        self.panelOutlet.backgroundColor = .clear

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 2 // if you like rounded corners
        self.layer.shadowOffset = CGSize(width: 0, height: 4) // 上向きの影
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        
        let RED: CGFloat   = 65/255
        let GREEN: CGFloat = 67/255
        let BLUE: CGFloat  = 69/255
        
        let min_size = min(self.panelOutlet.frame.width, self.panelOutlet.frame.height)
        let diameter = min_size * CGFloat(Loading.CIRCLE_RATE / 100.0)
        let radius = diameter / 2
        
        let clayer = CAShapeLayer()
        clayer.frame = CGRect(
            x: 0,
            y: 0,
            width: self.panelOutlet.frame.width,
            height: self.panelOutlet.frame.height
        )
        
        clayer.fillColor = UIColor.clear.cgColor
        clayer.strokeColor = UIColor(red: RED, green: GREEN, blue: BLUE, alpha: 0.15).cgColor
        clayer.lineWidth = 4.0
        self.fix_rect = CGRect(
            x: (self.panelOutlet.frame.width / 2.0) - radius,
            y: (self.panelOutlet.frame.height / 2.0) - radius,
            width: radius * 2,
            height: radius * 2
        )
        let path = UIBezierPath(ovalIn: self.fix_rect).cgPath
        clayer.path = path
        
        self.panelOutlet.layer.addSublayer(clayer)
        
        self.progress_layer = CAShapeLayer()
        self.progress_layer.frame = clayer.frame
        
        self.progress_layer.fillColor = clayer.fillColor
        self.progress_layer.strokeColor = UIColor(red: RED, green: GREEN, blue: BLUE, alpha: 1).cgColor
        self.progress_layer.lineWidth = clayer.lineWidth
        self.progress_layer.lineCap = kCALineCapRound
        
        self.panelOutlet.layer.addSublayer(self.progress_layer)
    }
    

    /** クローズ処理 */
    func startLoading() {

        self.open()

        self.panelOutlet.isHidden = false
        
        let radius = self.fix_rect.width / 2 //円の半径の設定
        
        let scircle = UIBezierPath(
            arcCenter: CGPoint(x: self.fix_rect.midX, y: self.fix_rect.midY),
            radius: radius,
            startAngle:  -(CGFloat.pi / 2),
            endAngle: CGFloat.pi + (CGFloat.pi / 2),
            clockwise: true
        )
        
        self.progress_layer.path = scircle.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = CFTimeInterval(1.0)
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        
        self.progress_layer.add(animation, forKey: "progress")
    }
    
    /**  */
//    func close(time: Int = 3) {
//        self.progress_layer.removeAnimation(forKey: "progress")
//        workItem = DispatchWorkItem() {
//        self.close()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: self.workItem!)
//    }

}





