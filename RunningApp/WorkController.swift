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
    
    var startCountTimer: Timer!
    var countImageView: UIImageView!
    var count = 0
    
    weak var timer: Timer!
    var startTime = Date()
    
    var locationManager: CLLocationManager!

    @IBOutlet weak var map: UIView!
    @IBOutlet weak var stopWatchLabel: UILabel!
    
    var mapView : MKMapView!
    var pin: MKPointAnnotation?
    
    // 縮尺
    var latDist : CLLocationDistance = 500
    var lonDist : CLLocationDistance = 500
    
    var firstPoint: CLLocation!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
//    let type: WorkType!
//    init(type: WorkType) {
//        self.type = type
//        super.init(nibName: nil, bundle: nil)
//    }
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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // 取得精度の設定
        locationManager.distanceFilter = 50  // 取得頻度の設定.
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        print("authorizationStatus:\(status.rawValue)");

        // まだ認証が得られていない場合は、認証ダイアログを表示
        // (このAppの使用中のみ許可の設定) 説明を共通の項目を参照
        if (status == .notDetermined) {
            
            self.locationManager.requestWhenInUseAuthorization()
            
        } else {

            // MapViewの生成
            mapView = MKMapView()
            mapView.frame = self.view.bounds
            mapView.delegate = self
            self.map.addSubview(mapView)
            
            let coordinate = locationManager.location?.coordinate
            mapView.centerCoordinate = coordinate! // mapViewのcenterを現在地に

            // 表示領域を作成
            let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate!, self.latDist, self.lonDist);
            
            mapView.setRegion(region, animated: true)  // MapViewに反映
            
            let pin: MKPointAnnotation = MKPointAnnotation() // ピンを生成.
            
//            let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
            pin.coordinate =  coordinate! // 座標を設定.
            pin.title = "開始位置" // タイトルを設定.
//            pin.subtitle = "サブタイトル"  // サブタイトルを設定.
            mapView.addAnnotation(pin)  // MapViewにピンを追加.
            
            
            firstPoint = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
            
        }

    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.countImageAnimation()
        startCountTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countImageAnimation), userInfo: nil, repeats: true)
    }
    

    /** countImageViewのアニメーション
      */
    func countImageAnimation() {
        
        count = count + 1
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: { _ in
            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)

        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: { _ in
            self.countImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.countImageView.alpha = 0
        }, completion: { _ in
            self.countImageView.image = UIImage(named: "\(self.count).jpg")!
            self.countImageView.alpha = 1
            
            if self.count == 4 {
                self.countImageView.removeFromSuperview()
                self.startCountTimer.invalidate()
                self.startTimer()
            }
        })

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    
    func startTimer() {
        if timer != nil{
            // timerが起動中なら一旦破棄する
            timer.invalidate()
        }

        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
        
        startTime = Date()
    }
    
    func timerCounter() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime)
        
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        
        // %02d： ２桁表示、0で埋める
        stopWatchLabel.text = "\(String(format:"%02d", minute)):\(String(format:"%02", second))"
    }
    
    func stopTimer() {
        if timer != nil{
            timer.invalidate()
            stopWatchLabel.text = "00::00:00"
        }
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
                locationManager.startUpdatingLocation()

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

            
            let currentPoint: CLLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let distance = self.firstPoint.distance(from: currentPoint)
            print("distance = \(distance)")

            print((round( (distance) * 100) / 100) * 0.01 )
            self.distanceLabel.text = String( (round(distance * 100) / 100) * 0.01 )
            
            
            // Regionを作成.
            let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, self.latDist, self.lonDist);
            mapView.setRegion(region, animated: true) // MapViewに反映.
            
            if self.pin != nil {
                mapView.removeAnnotation(self.pin!)
            }

            self.pin = MKPointAnnotation() // ピンを生成.
            self.pin?.coordinate = location.coordinate // 座標を設定.
            self.pin?.title = "開始現在" // タイトルを設定.
            mapView.addAnnotation(self.pin!)  // MapViewにピンを追加.
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











