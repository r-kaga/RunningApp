//
//  resultView.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/15.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

@IBDesignable
class resultView: UIView {
    
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var dateTimeValueLabel: UILabel!
    
    @IBOutlet weak var timeValueLabel: UILabel!
    
    @IBOutlet weak var distanceValueLabel: UILabel!
    
    @IBOutlet weak var speedValueLabel: UILabel!
    
    @IBOutlet weak var calorieValueLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var indexPath: Int?
    
    var closeButton: UIButton!
    
    var loading: Loading?
    
    @IBAction func deleteAction(_ sender: Any) {
        delete()
    }
    
    
    /** イニシャライザー
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true

        self.loadFromNib()
//        self.setUpCloseButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadFromNib()
//        self.setUpCloseButton()
    }
    
    
    /** Nibファイル読み込み
     */
    private func loadFromNib() {
        
        let view = Bundle.main.loadNibNamed("resultView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
    
        self.addSubview(view)
        
        self.deleteButton.isHidden = true
        
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

    
//    private func setUpCloseButton() {
//
//        closeButton = UIButton(frame: CGRect(x: self.frame.width - 40, y: 0, width: 40, height: 40))
//        closeButton.backgroundColor = .clear
//        closeButton.setTitle("❌", for: .normal)
//        //        button.setImage(UIImage(named: "close")!, for: .normal)
//        closeButton.addTarget(self, action: #selector(resultView.buttonTaped(_:)), for: .touchUpInside)
//        self.addSubview(closeButton)
//
//    }
//
//    @objc func  buttonTaped(_ sender: AnyObject) {
//        delete()
//    }
//
    
    
    private func delete() {
        
        defer {
            //            let vc = AppDelegate.getTopMostViewController()
            //            vc.loadView()
            //            vc.viewDidLoad()
        }
        
        let alert = UIAlertController(title: "削除してよろしいですか", message: "データは残りません", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            
//            defer {
//                self.loading?.close()
//            }
            
            guard let path = self.indexPath else { return }
            
//            self.loading = Loading.make()
//            self.loading?.startLoading()
            
            let realm = try! Realm()
            let data = realm.objects(RealmDataSet.self).filter("id = \(path)")
            
            try! realm.write() {
                realm.delete(data)
            }
            
            self.removeFromSuperview()
            let vc = AppDelegate.getTopMostViewController()
            vc.loadView()
            vc.viewDidLoad()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            print("cencel")
        }))
        
        AppDelegate.getTopMostViewController().present(alert, animated: true)
    }

    
    private func drawBadge() {
        let labelText = CATextLayer() // textを描画するためのCALayer
        labelText.contentsScale = UIScreen.main.scale // バッジラベルに適用される倍率. 現在のディスプレイのスケールを取得
        labelText.string = "❌" // バッジに表示する値
        labelText.fontSize = 15.0 // fontSize
        labelText.font = UIFont.systemFont(ofSize: 15) // fontの種類
        labelText.alignmentMode = kCAAlignmentCenter // center寄せ
        labelText.foregroundColor = UIColor.white.cgColor // CATextLayerのtextColorの変更
        labelText.frame = CGRect(x: self.frame.width - 15, y: -10, width: 30, height: 30) // badgeのlabelのframe
        let shapeLayer = CAShapeLayer() // 図を描画するためのCALayer
        shapeLayer.contentsScale = UIScreen.main.scale // レイヤーに適用される倍率. 現在のディスプレイのスケールを取得
//        let cornerRadius = CGFloat(labelText.frame.width) // 丸め幅
//        let borderInset = CGFloat(-2.0) // badgetextのpadding. 赤丸までどれくらい空けるか

        /** UIBezierPath -> 図形を描画
         *  roundedRectでのinitは、角が丸い矩形を描画する
         *    roundedRect -> 図形の形状を定義 CGRect
         *  byRoundingCorners -> 丸めたいコーナーを設定
         *    cornerRadius -> 楕円の半径
         *  insetBy -> Marginをつける labelTextから広がる形のCGRect dx - x座標, dy - y座標
         */
//        let aPath = UIBezierPath(roundedRect: labelText.frame.insetBy(dx: borderInset, dy: borderInset), cornerRadius: cornerRadius)
//        let aPath = UIBezierPath(rect: labelText.frame)
//        shapeLayer.path = aPath.cgPath //図形を描画
//        shapeLayer.fillColor = UIColor.white.cgColor // 図形の中の色
//        shapeLayer.strokeColor = UIColor.white.cgColor // 輪郭の線の色
//        shapeLayer.lineWidth = 0.5 // 輪郭の線の太さ
        
        /** layerを追加
         *  index - layerのindex番号 階層の0番目にレイヤーを追加
         */
//        shapeLayer.insertSublayer(labelText, at: 0)
        
        // 追加したlayerのframe. 継承させたButtonの中での座標
//        shapeLayer.frame = shapeLayer.frame.offsetBy(dx: self.frame.width, dy: 0.0)
        
//        self.layer.insertSublayer(shapeLayer, at: 1)
        self.layer.insertSublayer(labelText, at: 1)

        // trueにすると、円の上が切れる. レイヤの境界に一致する暗黙のクリッピングマスクを作成する maskプロパティも指定されている場合は、2つのマスクを乗算して最終的なマスク値を取得します。
        self.layer.masksToBounds = false

        self.layer.addSublayer(labelText)

    }

    public func setValueToResultView(dateTime: String, timeValue: String, distance: String, speed: String, calorie: String) {
        setSpeedLabel(value: speed)
        setDateTimeLabel(value: dateTime)
        setTimeLabel(value: timeValue)
        setDistanceLabel(value: distance + "km")
        setCalorieLabel(value: calorie)
    }
    
    public func setSpeedLabel(value: String) {
        self.speedValueLabel.text = value
    }
    
    public func setDateTimeLabel(value: String) {
        self.dateTimeValueLabel.text = value
    }
    
    public func setTimeLabel(value: String) {
        self.timeValueLabel.text = value
    }
    
    public func setDistanceLabel(value: String) {
        self.distanceValueLabel.text = value
    }
    
    public func setCalorieLabel(value: String) {
        self.calorieValueLabel.text = value
    }
    
}












