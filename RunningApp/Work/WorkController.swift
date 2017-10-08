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
    
    @IBOutlet weak var speedLabel: UILabel!
    var mapView : MKMapView!
    var pin: MKPointAnnotation?
    
    // 縮尺
    var latDist : CLLocationDistance = 500
    var lonDist : CLLocationDistance = 500
    
    var firstPoint: CLLocation!
    
    var currentPoint: CLLocation?
    var previousPoint: CLLocation?
    
    var totalDistance: Double = 0.0
    
    @IBOutlet weak var distanceLabel: UILabel!

    
    @IBAction func handleGesture(_ sender: Any) {
        print("fwafweafewa")
        weak var nc = navigationController as? ModalNavigationController
        nc?.handleGesture(sender as! UIPanGestureRecognizer)
    }
    
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
        
        self.locationManager = CLLocationManager() // インスタンスの生成
        self.locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 取得精度の設定
        self.locationManager.distanceFilter = 10  // 取得頻度の設定.
        self.locationManager.activityType = .fitness
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()

//        // まだ認証が得られていない場合は、認証ダイアログを表示
//        // (このAppの使用中のみ許可の設定) 説明を共通の項目を参照
        if (status == .notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        } else {

            // MapViewの生成
            mapView = MKMapView()
            mapView.frame = self.view.bounds
            mapView.delegate = self
            self.map.addSubview(mapView)
            
            let coordinate = locationManager.location?.coordinate

            // 表示領域を作成
            let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate!, self.latDist, self.lonDist);
            
            mapView.setRegion(region, animated: true)  // MapViewに反映
            
            let firstPin: MKPointAnnotation = MKPointAnnotation() // ピンを生成.
//            let center: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
            firstPin.coordinate =  coordinate! // 座標を設定.
            firstPin.title = "開始位置" // タイトルを設定.
//            pin.subtitle = "サブタイトル"  // サブタイトルを設定.
            mapView.addAnnotation(firstPin)  // MapViewにピンを追加.
            
            firstPoint = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)

            self.mapView.centerCoordinate = firstPin.coordinate // mapViewのcenterを現在地に
        }

    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.countImageAnimation()
        startCountTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countImageAnimation), userInfo: nil, repeats: true)
    }
    

    /** countImageViewのアニメーション
      */
    @objc func countImageAnimation() {
        
        count = count + 1
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: { 
            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)

        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: { 
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
    
    @objc func timerCounter() {
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
        self.dismiss(animated: true, completion: {
            if self.pin != nil {
                self.mapView.removeAnnotation(self.pin!)
            }
            self.mapView.removeFromSuperview()
            self.mapView = nil
        })
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
//                locationManager.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める

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
    
        // 配列から現在座標を取得.
        guard let location: CLLocation = locations.last else { return }
        
//       guard self.previousPoint != nil {
        guard let previous = self.previousPoint else {
            let distance = self.firstPoint.distance(from: location)
            self.totalDistance += floor(distance)
            self.previousPoint = location
            return
        }
        
        guard !previous.isEqual(location) else {
            print("ddergergregre")
            return
        }
        
        let distance = self.firstPoint.distance(from: location)
        
//        let distance = previous.distance(from: location)
        guard distance > 10.0 else { return }
        //        totalDistance += floor(distance)
        totalDistance = distance
        self.previousPoint = location

//        let dis = distance / 1000.0 > 1.0 ? round( (distance / 1000.0) * 100) / 100 : round( (distance / 100.0) * 100 ) / 100
        let dis = round( (distance / 1000.0) * 100) / 100
        self.distanceLabel.text = String(dis)
 
        // Regionを作成.
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, self.latDist, self.lonDist)
        self.mapView.setRegion(region, animated: true) // MapViewに反映.
        
        if self.pin != nil {
            self.mapView.removeAnnotation(self.pin!)
        }

        self.pin = MKPointAnnotation() // ピンを生成.
        self.pin?.coordinate = location.coordinate // 座標を設定.
        self.pin?.title = "現在地" // タイトルを設定.
        self.mapView.addAnnotation(self.pin!)  // MapViewにピンを追加.
        
        // 直線を引く座標を作成.
//        let currentCorrdinate = location.coordinate
        let currentCorrdinate = self.firstPoint.coordinate
        guard let priviousCoordinate = self.previousPoint?.coordinate else { return }
        
        // 座標を配列に格納.
        var line = [CLLocationCoordinate2D]()
        line.append(currentCorrdinate)
        line.append(priviousCoordinate)
        let polyLine: MKPolyline = MKPolyline(coordinates: &line, count: line.count)
        self.mapView.add(polyLine)  // mapViewにcircleを追加.


        let time = Date().timeIntervalSince(self.startTime)
        // fmod() 余りを計算
        let minute = (Int)(fmod((time/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(time, 60))
    
        let elapsedTime = Double((minute * 60) + second)
        
        guard totalDistance != 0.0  else { return }
        
        let spped =  totalDistance / 1000 + elapsedTime * 60 * 60
        self.speedLabel.text = String(spped)
        
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
//        print("regionDidChangeAnimated")
    }
    
    
    /*
     addOverlayした際に呼ばれるデリゲートメソッド.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        // 線の太さを指定.
        myPolyLineRendere.lineWidth = 5
        
        // 線の色を指定.
        myPolyLineRendere.strokeColor = UIColor.red
        
        return myPolyLineRendere
    }
    
    
}











