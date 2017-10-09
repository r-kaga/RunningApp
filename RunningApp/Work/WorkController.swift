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
        self.dismiss(animated: true, completion: {
            if self.pin != nil {
                self.mapView.removeAnnotation(self.pin!)
            }
            self.mapView.removeFromSuperview()
//            self.mapView = nil
        })
//        weak var nc = navigationController as? ModalNavigationController
//        nc?.handleGesture(sender as! UIPanGestureRecognizer)
    }
    
    
    lazy var mapView: MKMapView = {
        // MapViewの生成
        let mapView = MKMapView()
        mapView.frame = self.view.bounds
        mapView.delegate = self
        return mapView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Ranrastic"

        countImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppSize.width / 3, height: AppSize.height / 3))
        countImageView.center = self.view.center
        countImageView.image = UIImage(named: "num3")!
        countImageView.contentMode = .scaleAspectFit
        countImageView.isHidden = true
        self.view.addSubview(countImageView)
        
        self.map.addSubview(self.mapView)
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countImageView.isHidden = false
        self.countImageAnimation()
    }
    

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
    }
    
    

    /** countImageViewのアニメーション
      */
    @objc func countImageAnimation() {

        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }, completion: { _ in

            self.countImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.countImageView.image = UIImage(named: "num2")!

            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            }, completion: { _ in

                self.countImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.countImageView.image = UIImage(named: "num1")!

                UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {

                    self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

                }, completion: { _ in

                    self.countImageView.isHidden = true
                    self.countImageView.removeFromSuperview()
                    self.startTimer()
                    self.setupLocationManager()

                })

            })
            
        })

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
//            self.mapView = nil
        })
    }
    
    
    /* 時速の計算結果
     */
    private func getCalculateSpeed() -> Double {
        let time = Date().timeIntervalSince(self.startTime)
        // fmod() 余りを計算
        let minute = (Int)(fmod((time/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(time, 60))
        
        let elapsedTime = Double((minute * 60) + second)
        
        guard totalDistance != 0.0  else {
            return 0.0
        }
        
        let spped =  totalDistance / 1000 + elapsedTime * 60 * 60
        return spped
    }
    
    
    private func getDistance(location: CLLocation) -> String {
        let distance = self.firstPoint.distance(from: location)
    //        let distance = previous.distance(from: location)
        totalDistance = distance
        self.previousPoint = location

        let dis = round( (distance / 1000.0) * 100) / 100
        return String(dis)
    }
    
}



extension WorkController: CLLocationManagerDelegate {
    
    
    
    private func setupLocationManager() {
        self.locationManager = CLLocationManager() // インスタンスの生成
        self.locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 取得精度の設定
        self.locationManager.distanceFilter = 10  // 取得頻度の設定.
        self.locationManager.activityType = .fitness
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        switch status {
            // まだ認証が得られていない場合は、認証ダイアログを表示
        // (このAppの使用中のみ許可の設定) 説明を共通の項目を参照
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            print("設定から許可して下さい")
        case .authorizedAlways, .authorizedWhenInUse:
            self.markCurrentLocation()
        }
        
    }
    
    
    
    private func markCurrentLocation() {
        let coordinate = locationManager.location?.coordinate
        self.setRegion(coordinate: coordinate!)
        
        let firstPin: MKPointAnnotation = MKPointAnnotation() // ピンを生成.
        firstPin.coordinate =  coordinate! // 座標を設定.
        firstPin.title = "開始位置" // タイトルを設定.
        mapView.addAnnotation(firstPin)
        
        firstPoint = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        self.mapView.centerCoordinate = firstPoint.coordinate // mapViewのcenterを現在地に
    }
    

    
    
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
            
            case .restricted:
                print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
                // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            
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
                locationManager.activityType = .fitness
                self.markCurrentLocation()
                // 位置情報取得の開始処理

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

        // 現在地と開始位置の距離を取得
        self.distanceLabel.text = self.getDistance(location: location)
 
        // Regionを作成.
        self.setRegion(coordinate: location.coordinate)

        // pinをセット
        self.setPin(title: "現在地", coordinate: location.coordinate)

        // 直線を引く座標を作成.
        let currentCoordinate = location.coordinate
//        let currentCorrdinate = self.firstPoint.coordinate
        guard let priviousCoordinate = self.previousPoint?.coordinate else { return }
        self.drawLineToMap(from: priviousCoordinate, to: currentCoordinate)

        // 時速の計算結果をlabelに反映
        self.speedLabel.text = String(self.getCalculateSpeed())
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
    
    
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        // 表示領域を作成
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, self.latDist, self.lonDist);
        self.mapView.setRegion(region, animated: true)  // MapViewに反映
    }
    
    
    
    private func setPin(title: String, coordinate: CLLocationCoordinate2D) {
        if self.pin != nil {
            self.mapView.removeAnnotation(self.pin!)
        }
        
        self.pin = MKPointAnnotation() // ピンを生成.
        self.pin?.coordinate = coordinate // 座標を設定.
        self.pin?.title = title // タイトルを設定.
        self.mapView.addAnnotation(self.pin!)  // MapViewにピンを追加.
    }
    
    
    private func drawLineToMap(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        // 座標を配列に格納.
        var line = [CLLocationCoordinate2D]()
        line.append(from)
        line.append(to)
        let polyLine: MKPolyline = MKPolyline(coordinates: &line, count: line.count)
        self.mapView.add(polyLine)  // mapViewにcircleを追加.
    }
    
    
    
}











