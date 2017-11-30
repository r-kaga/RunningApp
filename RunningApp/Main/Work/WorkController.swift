
import Foundation
import UIKit
import CoreLocation
import MapKit
import RealmSwift
import CoreMotion

class WorkController: UIViewController {
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultCardView: UIView!
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var stopWatchLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    static var workType: String?
    static var homeDelegate: HomeDelegate?

    weak var timer: Timer!
    var startTimeDate: Date!
    
    weak var pausedTimer: Timer?
    var pausedTime: Int = 0
    
    private var isStarted = false
    
    let pedometer = CMPedometer()
    let cmAltimeter = CMAltimeter()
    let activityManager = CMMotionActivityManager()


    var locationManager: CLLocationManager!
    var pin: MKPointAnnotation?
    
    // 縮尺
    var latDist : CLLocationDistance = 500
    var lonDist : CLLocationDistance = 500
    
    var firstPoint: CLLocation!
    var previousPoint: CLLocation?
    
//    var minAltitude: CLLocationDistance?
//    var maxAltitude: CLLocationDistance?
    var minAltitude: Double?
    var maxAltitude: Double?
    
    var totalDistance: Double = 0.0
    
    var interactor: Interactor!
    
//    var isTransform: Bool = false
    
    /* カウントダウンのImageViewを生成 */
    lazy var countImageView: UIImageView = {
        let countImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppSize.width / 3, height: AppSize.height / 3))
        countImageView.center = CGPoint(x: AppSize.width / 2, y: AppSize.height / 2)
        countImageView.image = UIImage(named: "num3")!
        countImageView.contentMode = .scaleAspectFit
        countImageView.isHidden = true
        return countImageView
    }()
    
    /* 現在地を表示するMapKitを生成 */
    lazy var mapView: MKMapView = {
        // MapViewの生成
        let mapView = MKMapView()
        mapView.frame = CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height / 2)
        mapView.delegate = self
        return mapView
    }()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        resultCardView.layer.cornerRadius = 10.0
        resultCardView.clipsToBounds = true

        self.view.addSubview(countImageView)
        self.map.addSubview(mapView)
        
        self.setupLocationManager()
        
        let gradient = Gradiate(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height / 2))
        resultView.layer.addSublayer(gradient.setUpGradiate())
        gradient.animateGradient()

        resultView.bringSubview(toFront: resultCardView)
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
    

    /** countImageViewのアニメーション */
    @objc func countImageAnimation() {

        UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }, completion: { _ in

            self.countImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.countImageView.image = UIImage(named: "num2")!

            UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations: {
                
                self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

            }, completion: { _ in

                self.countImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.countImageView.image = UIImage(named: "num1")!

                UIView.animate(withDuration: 0.8, delay: 0.0, options: .curveEaseOut, animations: {

                    self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

                }, completion: { _ in

                    self.countImageView.isHidden = true
                    self.countImageView.removeFromSuperview()
                    self.isStarted = true
                    self.startTimer()
                    self.startPausedTime()
                })

            })
            
        })

    }

    
    /* ストップウォッチ */
    private func startTimer() {
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
        
        startTimeDate = Date()
    }

    /* labelに経過時間を表示 */
    @objc func timerCounter() {
        DispatchQueue.main.async {
            self.stopWatchLabel.text = self.getElapsedTime()
        }
    }
    
    /* タイマーの終了時処理 */
    private func stopTimer() {
        if timer != nil{
            timer.invalidate()
            stopWatchLabel.text = "00::00:00"
        }
    }
    
    
    private func startPausedTime()  {
        print("startPauseTimer")
        pausedTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(self.countPausedTimer),
            userInfo: nil,
            repeats: true)
    }
    
    @objc private func countPausedTimer(_ pause: Bool) {
        print(self.pausedTime)
        self.pausedTime += 1
    }
    
    private func pausedTimer(pause: Bool) {
        switch pause {
            case true:
                self.startPausedTime()
            case false:
                self.pausedTimer?.invalidate()
        }
    }

    
    /** DBに登録 */
    private func registWorkResult() {
        
//        print(self.minAltitude)
//        print(self.maxAltitude)
        
        guard let totalDistance  = self.distanceLabel.text,
              let speed      = self.speedLabel.text,
              let time       = self.stopWatchLabel.text,
              let calorie    = self.calorieLabel.text,
              let type       = WorkController.workType
//              let minAlt     = self.minAltitude,
//              let maxAlt     = self.maxAltitude
        else { return }
        
        
        let realm = try! Realm()
        let dataSet = RealmDataSet()
        
        if let id = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false).first?.id {
            dataSet.id = id + 1
        }
        dataSet.date        = Utility.getNowClockString()
        dataSet.calorie     = calorie
        dataSet.distance    = totalDistance
        dataSet.speed       = speed
        dataSet.time        = time
        dataSet.workType    = type
//        dataSet.minAlt      = minAlt
//        dataSet.maxAlt      = maxAlt
//        dataSet.pausedTime = self.pausedTime

        try! realm.write {
            realm.add(dataSet)
        }

    }
    
    /** 歩数を取得するためのSetup */
    private func setupPedometer() {
        guard CMPedometer.isDistanceAvailable() else { return }
        self.pedometer.startUpdates(from: NSDate() as Date) { (data: CMPedometerData?, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data, let dis = data.distance?.doubleValue, error == nil
                else { return }
 
                let distance = String(round( ( dis / 1000.0 ) * 100) / 100)
                self.distanceLabel.text = distance
                
                guard let pace = data.currentPace?.doubleValue else { return }
                self.speedLabel.text = String(round( ( (pace * 3600) / 100.0 ) * 100) / 100)
                
//                data.floorsAscended
//                data.floorsDescended
                
            }
        }
        
        self.pedometer.startEventUpdates { (event: CMPedometerEvent?, error: Error?) in
            guard let event = event, error == nil else { return }
            
            print(event.type.hashValue)
            
            switch event.type {
                case .pause:
                    self.pausedTimer(pause: true)
                case .resume:
                    self.pausedTimer(pause: false)
            }
        }
        
    }
    
    /** 高度を取得するためのSetup */
    private func setupAltitude() {
        // Altimeterのモニタリングのスタート.
        guard CMAltimeter.isRelativeAltitudeAvailable() else { return }
        self.cmAltimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: {(altimeterData, error) in
            guard error == nil else {
                //                    print(error?.localizedDescription)
                return
            }
            guard let altitude = altimeterData?.relativeAltitude.doubleValue
                else { return }
            
            if self.minAltitude == nil || self.maxAltitude == nil {
                self.minAltitude = altitude
                self.maxAltitude = altitude
            }
            
            guard let minAlt = self.minAltitude, let maxAlt = self.maxAltitude
                else { return }
            
            if minAlt > altitude {
                self.minAltitude = altitude
            }
            
            if maxAlt < altitude {
                self.maxAltitude = altitude
            }
            
        })
    }
    
//    private func setupActivityType() {
//        guard CMMotionActivityManager.isActivityAvailable() else { return }
//
//        self.activityManager.startActivityUpdates(to: OperationQueue.current!,withHandler: { (data: CMMotionActivity?) in
//
//            guard let isWalking = data?.walking,
//                  let isRunning = data?.running,
//                  let isStatinary = data?.stationary
//            else { return }
//
//            if isWalking {
////                self.walkingTime =
//            } else if isStatinary {
//                self.pausedTimer(pause: true)
//            } else if isRunning {
//                self.pausedTimer(pause: false)
//            }
//    
//        })
//    }


    
    /** 開始時間から現在の経過時間を返却
     * - return 現在の経過時間 / HH:mm:ss
     */
    private func getElapsedTime() -> String {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTimeDate)
        let hour = (Int)(fmod((currentTime / 60 / 60), 60))
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        return  "\(String(format:"%02d", hour)):\(String(format:"%02d", minute)):\(String(format:"%02", second))"
    }

//    /* 時速の計算結果
//     * return 時速の計算結果 type Double
//     */
//    private func getCalculateSpeed() -> Double {
//
////        let time = Date().timeIntervalSince(startTimeDate)
////        // fmod() 余りを計算
////        let minute = (Int)(fmod((time/60), 60))
////        // currentTime/60 の余り
////        let second = (Int)(fmod(time, 60))
////
////        let elapsedTime = Double((minute * 60) + second)
////        print(elapsedTime)
////
////        // タイマー開始からのインターバル時間
////        let currentTime = Date().timeIntervalSince(startTimeDate)
////
////        let hour = (Int)(fmod((currentTime / 60 / 60), 60))
////
////        // fmod() 余りを計算
////        let minutes = (Int)(fmod((currentTime/60), 60))
////
////        // currentTime/60 の余り
////        let seconds = (Int)(fmod(currentTime, 60))
////        print(hour + (minutes / 60) + (seconds / 60 / 60) )
//
////        guard totalDistance != 0.0  else {
////            return 0.0
////        }
//
////        let speed =  totalDistance / elapsedTime * 60 * 60
//        print(totalDistance / elapsedTime)
//
//        return speed
//    }
    
    /* 距離を取得
     * @param location - 現在地のCLLocation
     * @return 開始位置とlocationとの距離
     */
    private func getDistance(location: CLLocation) -> String {
        
        var distance: Double
        if let previous = self.previousPoint {
            distance = previous.distance(from: location)
        } else {
            distance = self.firstPoint.distance(from: location)
        }

        /** まずdistanceがメートルで返ってくるので、1000.0で割り、Kmに変換
         *   小数点2桁にしたいので、まずは100をかけて、round(四捨五入)してから、100で割り、元の桁に戻す
         */
        let dis = round( (distance / 1000.0) * 100) / 100

        totalDistance += dis
        self.previousPoint = location

        return String(totalDistance)
    }
    
    /** 計測終了確認アラート */
    private func confirmWorkEndAlert() {
        let alert = UIAlertController(title: "計測を終了します", message: "終了してもよろしいですか?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.registWorkResult()
            self?.dismissModal()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /* Modalを閉じる */
    private func dismissModal() {
        dismiss(animated: true, completion: { [presentingViewController] () -> Void in
            if self.pin != nil {
                self.mapView.removeAnnotation(self.pin!)
            }
            self.mapView.removeFromSuperview()
            
            //            let tabVC = presentingViewController as! MainTabBarViewController
            //            //Navigation Controllerを取得
            //            let nav = tabVC.viewControllers![0]  as! UINavigationController
            //
            //            //呼び出し元のView Controllerを遷移履歴から取得しパラメータを渡す
            //            let home = nav.viewControllers[nav.viewControllers.count-1] as! HomeViewController
            //            home.loadView()
            //            home.viewDidLoad()
            //            WorkController.homeDelegate?.dateUpdate()
//            presentingViewController?.loadView()
//            presentingViewController?.viewDidLoad()
//            presentingViewController?.viewWillAppear()
            
            Utility.showCompleteDialog()
        })
    }
    

    /** Endボタン押し時 */
    @IBAction func endAction(_ sender: Any) {
        confirmWorkEndAlert()
    }
    
    /** TapGesture */
    @IBAction func handleGesture(_ sender: Any) {
        confirmWorkEndAlert()
        //        weak var nc = navigationController as? ModalNavigationController
        //        nc?.handleGesture(sender as! UIPanGestureRecognizer)
        
        //        print("----------------------")
        //        if  isTransform {
        //
        //            UIView.animate(withDuration: 0.3) {
        //                self.map.alpha = 1.0
        //                //            self.resultView.alpha = 1.0
        //
        //                UIView.animate(withDuration: 0.5) {
        //                    //                self.map.frame = CGRect(x: AppSize.width - 150, y: AppSize.height - 150, width: 150, height: 150)
        //                    //                self.map.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        //                    self.resultView.frame = CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height / 2)
        ////                    self.resultView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        ////
        ////                    self.isTransform = false
        ////                }
        ////            }
        ////
        ////        } else {
        //
        //            UIView.animate(withDuration: 0.3) {
        //                self.map.alpha = 0.0
        //                //            self.resultView.alpha = 0.0
        //
        //                UIView.animate(withDuration: 1.0) {
        ////                    self.map.frame = CGRect(x: AppSize.width - 150, y: AppSize.height - 150, width: 150, height: 150)
        ////                    self.map.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        //                    self.resultView.frame = CGRect(x: AppSize.width - 150, y: AppSize.height - 150 - AppSize.tabBarHeight, width: 150, height: 150)
        //                    self.resultView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        //
        ////                    self.isTransform = true
        //
        //                }
        //            }
        ////        }
        //

    }
    

    
    
}



extension WorkController: CLLocationManagerDelegate {
    
    /* CoreLocationのSetup
     * 画面の表示時に行う必要のある処理
     */
    private func setupLocationManager() {
        self.locationManager = CLLocationManager() // インスタンスの生成
        self.locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 取得精度の設定
        self.locationManager.distanceFilter = 10  // 取得頻度の設定.
        self.locationManager.activityType = .fitness
        self.locationManager.pausesLocationUpdatesAutomatically = false
        
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
    
    
    /* 開始位置をMapにMarkする
     * Work開始時に行う必要のある処理
     */
    private func markCurrentLocation() {
        guard let coordinate = locationManager.location?.coordinate else {
            print("current is nil")
            return
        }
        self.setRegion(coordinate: coordinate)

        let firstPin: MKPointAnnotation = MKPointAnnotation() // ピンを生成.
        firstPin.coordinate =  coordinate // 座標を設定.
        firstPin.title = "開始位置" // タイトルを設定.
        mapView.addAnnotation(firstPin)
        
        firstPoint = CLLocation(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
//        self.mapView.centerCoordinate = firstPoint.coordinate // mapViewのcenterを現在地に
        setupPedometer()
    }
    
    
    /*  Location取得の認証に変化があった際に呼ばれる
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
                locationManager.activityType = .fitness

            case .authorizedWhenInUse:
                print("起動時のみ、位置情報の取得が許可されています。")
                locationManager.startUpdatingLocation()
                locationManager.activityType = .fitness
                self.markCurrentLocation()
        }
    }
    
    
    /* 位置情報取得に成功したときに呼び出されるデリゲート. */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        guard self.isStarted else { return }

        // 配列から現在座標を取得.
        guard let location: CLLocation = locations.first else { return }

        self.setRegion(coordinate: location.coordinate) // Regionを作成.
        self.setPin(title: "現在地", coordinate: location.coordinate) // pinをセット
//        self.drawLineToMap(from: previous.coordinate, to: location.coordinate) // 直線を引く座標を作成.
        
        
//        if self.minAltitude > location {
//            self.minAltitude = location.altitude
//        }
//        self.minAltitude = location.altitude
//        self.maxAltitude = location.altitude
        
        var calorie: Double = 0.0
        if let weight = UserDefaults.standard.string(forKey: "weight") {
            // タイマー開始からのインターバル時間
            let currentTime = Date().timeIntervalSince(startTimeDate)
            let hour = (Double)(fmod((currentTime / 60 / 60), 60))
            let minute = (Double)(fmod((currentTime/60), 60))
            let second = (Double)(fmod(currentTime, 60))

            let time = hour + (minute / 60) + (second / 60 / 60)

            let calcu = (1.05 * 8.0 * time * Double(weight)!)
            calorie = round(calcu * 10.0) / 10.0
//            【例　散歩：2.5METsの運動を1時間　体重52kgの場合】
//            1.05×2.5×1.0(時間)×52(kg)＝136.5（kcal）
//            1METS： 睡眠、TV鑑賞、安静時等
//            3METS： ウォーキング(少し遅い)
//            4METS： ウォーキング(少し速い)
//            5METS： 野球
//            7METS： テニス
//            8METS： サイクリング、ジョギング
//            9METS： 上の階へ荷物を運ぶ
//            10METS： ランニング（9.7km/h)、水泳（平泳ぎ）、サッカー
//            11METS： 水泳（クロール、バタフライ）、ランニング（10.8km/h)
//            15METS： ランニング(14.5km/h)、階段ダッシュ
        }
        // UIの更新
        DispatchQueue.main.async {
//            self.distanceLabel.text = self.getDistance(location: location)
            
            self.calorieLabel.text = String(calorie)

            // 時速の計算結果をlabelに反映
            let speed = round((location.speed * 3.6) * 10.0) / 10.0
            var speedText = String(speed)
            if speed < 0 { speedText = "計測不能" }
            self.speedLabel.text = speedText
        }
        
    }
    
    
    /* 位置情報取得に失敗した時に呼び出されるデリゲート. */
    func locationManager(_ manager: CLLocationManager,didFailWithError error: Error){
        print(error)
    }

}



extension WorkController: MKMapViewDelegate {
    
    // Regionが変更された時に呼び出されるメソッド
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        print("regionDidChangeAnimated")
//        let center = self.mapView.coordina
//        print(center)
//        self.mapView.setCenter(center, animated: true)
    }
    
    /* 現在の位置でMapを更新
     * @param coordinate 現在位置 CLLocationCoordinate2D
     */
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        // 表示領域を作成
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, self.latDist, self.lonDist)
//        let region = MKCoordinateRegionMake(coordinate, span)
//        region.center = coordinate
//        region.span.latitudeDelta = 0.003
//        region.span.longitudeDelta = 0.003
//        self.mapView.centerCoordinate = coordinate
        self.mapView.setRegion(region, animated: true)  // MapViewに反映
        self.mapView.setCenter(coordinate, animated: true)
    }
    
    
    /*
     * MapにPinをセットする
     * @param title - pinに表示するタイトル @type String
     * @param coordinate - pinをセットする位置 @type CLLocationCoordinate2D
     */
    private func setPin(title: String, coordinate: CLLocationCoordinate2D) {
        if self.pin != nil {
            self.mapView.removeAnnotation(self.pin!)
        }
        
        self.pin = MKPointAnnotation() // ピンを生成.
        self.pin?.coordinate = coordinate // 座標を設定.
        self.pin?.title = title // タイトルを設定.
        
        DispatchQueue.main.async {
            self.mapView.addAnnotation(self.pin!)  // MapViewにピンを追加.
        }
    }
    
    
    /*
     * Mapに直線を引く
     * @param from - 線の開始位置 type CLLocationCoordinate2D
     * @param to - 線の終了位置 type CLLocationCoordinate2D
     */
    private func drawLineToMap(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        // 座標を配列に格納.
        var line = [CLLocationCoordinate2D]()
        line.append(from)
        line.append(to)
        let polyLine: MKPolyline = MKPolyline(coordinates: &line, count: line.count)
        
        DispatchQueue.main.async {
            self.mapView.add(polyLine)  // mapViewにcircleを追加.
        }
        
    }
    
    
    /** addOverlayした際に呼ばれるデリゲートメソッド. */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // rendererを生成.
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        myPolyLineRendere.lineWidth = 2.5 // 線の太さを指定.
        myPolyLineRendere.strokeColor = UIColor.red // 線の色を指定.
        
        return myPolyLineRendere
    }
    
    
    
    
}







