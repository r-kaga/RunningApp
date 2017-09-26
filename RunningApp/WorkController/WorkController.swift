//
//  WorkOutController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/09/25.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


enum WorkType {
    case run
    case wallk
}

class WorkController: UIViewController {
    
    var timer: Timer!
    var countImageView: UIImageView!
    var count = 0
    
    var locationManager: CLLocationManager!

    
    var cnt:Double = 0
    var mapView : MKMapView!
    var coordinate: CLLocationCoordinate2D!
    

//    let type: WorkType!
    
//    init(type: WorkType) {
//        self.type = type
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Ranrastic"
//        
//        let workResultSpace = UIView(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height / 2))
//        workResultSpace.backgroundColor = .white
//        
//        let mainResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: workResultSpace.frame.height / 2))
//        mainResultLabel.text = "00:00:00"
//        mainResultLabel.backgroundColor = .white
//        mainResultLabel.textColor = .black
//        mainResultLabel.textAlignment = .center
//        mainResultLabel.font = UIFont.systemFont(ofSize: 25)
//        workResultSpace.addSubview(mainResultLabel)
//        
//        self.view.addSubview(workResultSpace)
        
        countImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppSize.width / 2, height: AppSize.height / 2))
        countImageView.center = self.view.center
        countImageView.image = UIImage(named: "0.jpg")!
        self.view.addSubview(countImageView)
        
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        
//        // セキュリティ認証のステータスを取得.
//        let status = CLLocationManager.authorizationStatus()
//        print("authorizationStatus:\(status.rawValue)");
//
//        // まだ認証が得られていない場合は、認証ダイアログを表示
//        // (このAppの使用中のみ許可の設定) 説明を共通の項目を参照
//        if(status == .notDetermined) {
//            self.myLocationManager.requestWhenInUseAuthorization()
//        }
//
//        // 取得精度の設定.
//        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
//        // 取得頻度の設定.
//        myLocationManager.distanceFilter = 100
        
        
        
        // MapViewの生成
        mapView = MKMapView()
        mapView.frame = self.view.bounds
        // Delegateを設定
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        // 中心点の緯度経度
        let lat: CLLocationDegrees = 35.681298
        let lon: CLLocationDegrees = 139.766247
        coordinate = CLLocationCoordinate2DMake(lat, lon)
        
        // 縮尺
        let latDist : CLLocationDistance = 1000 // 000
        let lonDist : CLLocationDistance = 1000 // 000
        
        // 表示領域を作成
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, latDist, lonDist);
        
        // MapViewに反映
        mapView.setRegion(region, animated: true)
        
        // タイマーを作る
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onUpdate(_:)), userInfo: nil, repeats: true)
 
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.countImageAnimation), userInfo: nil, repeats: true)
    }
    
    
    // scheduledTimerで指定された秒数毎に呼び出されるメソッド.
    func onUpdate(_ timer : Timer){
        
        cnt += 100.0
        
        //桁数を指定して文字列を作る.
        let str = "Time:".appendingFormat("%.1f",cnt)
        print(str)
        
        
        // 縮尺
        let latDist: CLLocationDistance = 1000 + cnt
        let lonDist: CLLocationDistance = 1000 + cnt
        
        
        // 表示領域を作成
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, latDist, lonDist);
        
        // MapViewに反映
        mapView.setRegion(region, animated: true)
        
    }
    

    /** countImageViewのアニメーション
      */
    func countImageAnimation() {
        
        count = count + 1
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseOut, animations: { _ in
            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { _ in
            self.countImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.countImageView.alpha = 0
        }, completion: { _ in
            self.countImageView.image = UIImage(named: "\(self.count).jpg")!
            self.countImageView.alpha = 1
            
            if self.count == 4 {
                self.countImageView.removeFromSuperview()
                self.timer.invalidate()
            }
        })

    }
    
    /** Endボタン押し時
      *
      */
    @IBAction func endAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}



extension WorkController: CLLocationManagerDelegate {
    
    /*
     認証に変化があった際に呼ばれる
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            locationManager.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める

        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            locationManager.startUpdatingLocation()
            
            /*
             other その他（デフォルト値）
             automotiveNavigation 自動車ナビゲーション用
             fitness 歩行者
             otherNavigation その他のナビゲーションケース（ボート、電車、飛行機)
             */
            locationManager.activityType = .fitness

        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
    }
    
    
    /*
     位置情報取得に成功したときに呼び出されるデリゲート.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
        }
    }
    
    /*
     位置情報取得に失敗した時に呼び出されるデリゲート.
     */
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print(error)
    }


}



extension WorkController: MKMapViewDelegate {
    
    // Regionが変更された時に呼び出されるメソッド
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }
    
}











