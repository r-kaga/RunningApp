//
//  UIPanGestureRecognizer.swift
//  sampleUIViewApp
//
//  Created by 加賀谷諒 on 2017/06/27.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//
//

import UIKit

class UIPanGestureRecognizer: UIViewController {
    
    private var tapLabel: UILabel!
    private var pinchGestureLabel: UILabel!
    private var swipeLabel: UILabel!
    private var longPressLabel: UILabel!
    private var panLabel: UILabel!
    private var rotateLabel: UILabel!
    private var edgeLabel: UILabel!
    var count = 0
    var longStr = "On"
    
    @IBOutlet weak var shakeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景を白色に.
        self.view.backgroundColor = UIColor.white
        
        // タップを認識.
        let myTap = UITapGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.tapGesture(sender:)))
        
        // ピンチを認識.
        let myPinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.pinchGesture(sender:)))
        
        // スワイプ認識.
        let mySwipe = UISwipeGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.swipeGesture(sender:)))
        
        // スワイプ認識-2本指でスワイプ.
        mySwipe.numberOfTouchesRequired = 2
        
        // 長押しを認識.
        let myLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.longPressGesture(sender:)))
        
        // 長押し-最低2秒間は長押しする.
        myLongPressGesture.minimumPressDuration = 1.0
        
        // 長押し-指のズレは15pxまで.
        myLongPressGesture.allowableMovement = 150
        
        // パン認識.
//        let myPan = UIPanGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.panGesture(sender:)))
        
//        // パン（フリック）ジェスチャーのレコグナイザを定義、自分で定義した関数「panGesture」を呼び出すようにする
//        let myPan = UIPanGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.panGesture(sender:)))
//        
//        
//        
        // パン認識-3本指でパン.
//        myPan.minimumNumberOfTouches = 3
        
        // 回転を認識.
        let myRotate = UIRotationGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.rotateGesture(sender:)))
        
        // エッジを認識.
        let mySEdghePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(UIPanGestureRecognizer.edgeGesture(sender:)))
        
        // エッジを認識-最低指3本で反応.
        mySEdghePan.minimumNumberOfTouches = 4
        
        // エッジを認識-左側.
        mySEdghePan.edges = UIRectEdge.left
        
        // Viewに追加.
        self.view.addGestureRecognizer(myTap)
        self.view.addGestureRecognizer(myPinchGesture)
        self.view.addGestureRecognizer(mySwipe)
        self.view.addGestureRecognizer(myLongPressGesture)
//        self.view.addGestureRecognizer(myPan)
        self.view.addGestureRecognizer(myRotate)
        self.view.addGestureRecognizer(mySEdghePan)
        
        let centerOfX = self.view.bounds.width / 2
        
        // Labelを作成.
        tapLabel = makeMyLabel(title: "Tap", color: UIColor.red, myX: centerOfX - 50 , myY: 100)
        pinchGestureLabel = makeMyLabel(title: "Pinch", color: UIColor.green, myX: centerOfX + 50, myY: 100)
        swipeLabel = makeMyLabel(title: "Swipe", color: UIColor.blue, myX: centerOfX - 50, myY: 190)
        longPressLabel = makeMyLabel(title: "Long", color: UIColor.orange, myX: centerOfX + 50, myY: 190)
        panLabel = makeMyLabel(title: "Pan", color: UIColor.black, myX: centerOfX - 50, myY: 280)
        rotateLabel = makeMyLabel(title: "Rotate", color: UIColor.cyan, myX: centerOfX + 50, myY: 280)
        edgeLabel = makeMyLabel(title: "Edge", color: UIColor.purple, myX: centerOfX - 50, myY: 370)
        
        // Viewに貼付ける.
        self.view.addSubview(tapLabel)
        self.view.addSubview(pinchGestureLabel)
        self.view.addSubview(swipeLabel)
        self.view.addSubview(longPressLabel)
        self.view.addSubview(panLabel)
        self.view.addSubview(rotateLabel)
        self.view.addSubview(edgeLabel)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shakeLabel.text = "Shaken, not Stirred"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     タップイベント.
     */
    internal func tapGesture(sender: UITapGestureRecognizer){
        DispatchQueue.main.async(execute: {
            self.tapLabel.text = "\(self.count)"
        })
        count += 1
    }
    
    /*
     ピンチイベントの実装.
     */
    internal func pinchGesture(sender: UIPinchGestureRecognizer){
        let firstPoint = sender.scale
        let secondPoint = sender.velocity
        pinchGestureLabel.text = "\(Double(Int(firstPoint*100))/100)\n\(Double(Int(secondPoint*100))/100)"
    }
    
    /*
     スワイプイベント
     */
    internal func swipeGesture(sender: UISwipeGestureRecognizer){
        let touches = sender.numberOfTouches
        print(sender)
        swipeLabel.text = "\(arc4random())"
    }
    
    /*
     長押しイベント.
     */
    internal func longPressGesture(sender: UILongPressGestureRecognizer){
        // 指が離れたことを検知
        if(sender.state == UIGestureRecognizerState.ended) {
            longPressLabel.text = self.longStr
            if longStr == "Off" {
                longStr = "On"
            } else {
                longStr = "Off"
            }
        }
    }
    
    /*
     パン.
     */
    internal func panGesture(sender: UIPanGestureRecognizer){
//        panLabel.text = "\(sender.numberOfTouches)"
    }
    
    /*
     回転.
     */
    internal func rotateGesture(sender: UIRotationGestureRecognizer){
        
        let firstPoint = sender.rotation
        let secondPoint = sender.velocity
        rotateLabel.text = "\(Double(Int(firstPoint*100))/100)\n\(Double(Int(secondPoint*100))/100)"
        
    }
    
    /*
     エッジ.
     */
    internal func edgeGesture(sender: UIScreenEdgePanGestureRecognizer){
        let touches = sender.numberOfTouches
        swipeLabel.text = "\(touches)"
    }
    
    internal func makeMyLabel(title: NSString, color: UIColor, myX: CGFloat, myY: CGFloat) -> UILabel{
        let myLabel: UILabel = UILabel()
        myLabel.frame = CGRect(x:0,y:0,width:80,height:80)
        myLabel.backgroundColor = color
        myLabel.textColor = UIColor.white
        myLabel.layer.masksToBounds = true
        myLabel.text = title as String
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.layer.cornerRadius = 40.0
        myLabel.layer.position = CGPoint(x: myX, y: myY)
        myLabel.numberOfLines = 2
        return myLabel
    }
    
}
