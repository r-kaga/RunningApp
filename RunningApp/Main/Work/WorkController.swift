
import Foundation
import UIKit
import CoreLocation
import MapKit
import RealmSwift
import CoreMotion
import AVFoundation


enum currentSpeedType {
    case up
    case down
    case maintain
    case notMatched
}

class WorkController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultCardView: UIView!
    @IBOutlet weak var map: UIView!
    @IBOutlet weak var stopWatchLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    weak private var timer: Timer?
    private var startTimeDate: Date!
    
    private let pedometer = CMPedometer()
    private var locationManager: CLLocationManager!
    private var pin: MKPointAnnotation?
    
    private var audioPlayer: AVAudioPlayer!
    
    // 縮尺
    private var latDist: CLLocationDistance = 500
    private var lonDist: CLLocationDistance = 500

    private var isStarted = false

    /* 現在地を表示するMapKitを生成 */
    lazy private var mapView: MKMapView = {
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
    
    
    /** 歩数を取得するためのSetup */
    private func setupPedometer() {
        guard CMPedometer.isDistanceAvailable() else { return }
        self.pedometer.startUpdates(from: NSDate() as Date) { (data: CMPedometerData?, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data, let dis = data.distance?.doubleValue, error == nil
                    else { return }
                
                let distance = String(round( ( dis / 1000.0 ) * 100) / 100)
                self.distanceLabel.text = distance
                
                //                guard let spped = data.currentPace?.doubleValue else { return }
                //                let pace = round( ( (spped * 3600) / 100.0 ) * 100) / 100
                //                self.speedLabel.text = String(pace)
                //                switch self.checkCurrentSpeedIsPaceable(currentSpeed: pace) {
                //                    case .up:
                //                        self.audioPlay(url: "speedUp")
                //                    case .down:
                //                        self.audioPlay(url: "speedDown")
                //                    case .maintain:
                //                        self.audioPlay(url: "maintain")
                //                    case .notMatched: break
                //                }
                
            }
        }
        
    }

    
    /** 音声を再生 */
    private func audioPlay(url: String) {
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: url, ofType:"mp3")!)
        
        // auido を再生するプレイヤーを作成する
        var audioError: NSError?
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioPath)
        } catch let error as NSError {
            audioError = error
            audioPlayer = nil
        }
        if let error = audioError {
            print("Error \(error.localizedDescription)")
        }
        
        audioPlayer.delegate = self
        //        audioPlayer.prepareToPlay()
        
        audioPlayer.play()
    }
    
    /** 現在のスピードと設定した理想のペースを比較する */
    private func checkCurrentSpeedIsPaceable(currentSpeed: Double, pace: Double) -> currentSpeedType{
        var type: currentSpeedType?
        
        switch currentSpeed {
        case let e where e < pace:
            type = .up
        case let e where e > pace + 1.0:
            type = .down
        case pace + 0.0...pace + 0.9:
            type = .maintain
        default:
            type = .notMatched
        }
        return type!
    }
    
    /** カロリー計算 */
    private func getCurrentCalorieBurned() -> Double {
        
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
        }
        return calorie
    }
    
    //MARK: - CountDownImageView
    /* カウントダウンのImageViewを生成 */
    lazy private var countImageView: UIImageView = {
        let countImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppSize.width / 3, height: AppSize.height / 3))
        countImageView.center = CGPoint(x: AppSize.width / 2, y: AppSize.height / 2)
        countImageView.image = UIImage(named: "num3")!
        countImageView.contentMode = .scaleAspectFit
        countImageView.isHidden = true
        return countImageView
    }()
    
    
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
                })

            })
            
        })

    }

    //MARK: - ElapsedTimer
    /* ストップウォッチ */
    private func startTimer() {
        if timer != nil{
            timer?.invalidate()
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
            timer?.invalidate()
            stopWatchLabel.text = "00::00:00"
        }
    }
 
    
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

    
    /** DBに登録 */
    private func registWorkResult() {
        
        guard let totalDistance  = self.distanceLabel.text,
              let speed      = self.speedLabel.text,
              let time       = self.stopWatchLabel.text,
              let calorie    = self.calorieLabel.text
        else { return }
        
        let realm = RealmDataSet.realm
        let dataSet = RealmDataSet()

        dataSet.id          = dataSet.getNewId
        dataSet.date        = Utility.getNowClockString()
        dataSet.calorie     = calorie
        dataSet.distance    = totalDistance
        dataSet.speed       = speed
        dataSet.time        = time

        try! realm.write {
            realm.add(dataSet)
        }

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
        
        self.timer?.invalidate()
        
        dismiss(animated: true, completion: { [presentingViewController] () -> Void in
            if self.pin != nil {
                self.mapView.removeAnnotation(self.pin!)
            }
            
            self.mapView.removeFromSuperview()
            Utility.showCompleteDialog()
            
//            presentingViewController
//            WorkController.homeDelegate?.dateUpdate()
            
            HomeViewController.shouldDateUpdate = true
            MyInfoViewController.shouldDateUpdate = true

            presentingViewController?.viewWillAppear(true)
        })
    }
    

    /** Endボタン押し時 */
    @IBAction func endAction(_ sender: Any) {
        confirmWorkEndAlert()
    }
    
    /** TapGesture */
    @IBAction func handleGesture(_ sender: Any) {
        confirmWorkEndAlert()
    }

//    private var previousPoint: CLLocation?
//    private var totalDistance: Double = 0.0
    /* 距離を取得
     * @param location - 現在地のCLLocation
     * @return 開始位置とlocationとの距離
     */
//    private func getDistance(location: CLLocation) -> String {
//
//        var distance: Double
//        if let previous = previousPoint {
//            distance = previous.distance(from: location)
//        } else {
//            distance = self.firstPoint.distance(from: location)
//        }
//
//        /** まずdistanceがメートルで返ってくるので、1000.0で割り、Kmに変換
//         *   小数点2桁にしたいので、まずは100をかけて、round(四捨五入)してから、100で割り、元の桁に戻す
//         */
//        let dis = round( (distance / 1000.0) * 100) / 100
//
//        totalDistance += dis
//        self.previousPoint = location
//
//        return String(totalDistance)
//    }
    
    
}



extension WorkController: CLLocationManagerDelegate {
    
    /* CoreLocationのSetup
     * 画面の表示時に行う必要のある処理
     */
    private func setupLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // 取得精度の設定
        self.locationManager.distanceFilter = 100  // 取得頻度の設定
        self.locationManager.activityType = .fitness
        self.locationManager.pausesLocationUpdatesAutomatically = false
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        switch status {
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
        guard let coordinate = locationManager.location?.coordinate else { return }
        self.setRegion(coordinate: coordinate)

        let firstPin: MKPointAnnotation = MKPointAnnotation() // ピンを生成.
        firstPin.coordinate =  coordinate // 座標を設定.
        firstPin.title = "開始位置" // タイトルを設定.
        mapView.addAnnotation(firstPin)

        setupPedometer()
    }
    
    
    /**  Location取得の認証に変化があった際に呼ばれる */
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
            case .authorizedWhenInUse, .authorizedAlways:
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

        //MARK: - ペースメーカー
        let currentSpeed = round((location.speed * 3.6) * 10) / 10
        var pace: Double = Const.defaulPaceSpeed
        if let value = UserDefaults.standard.object(forKey: "pace") as? Int {
            pace = Double(value)
        }
        print(currentSpeed)
        print(pace)
        pace = Double(25)
        switch checkCurrentSpeedIsPaceable(currentSpeed: currentSpeed, pace: pace) {
            case .up:
                print("speedUp")
                audioPlay(url: "speedUp")
            case .down:
                print("speedDown")
                audioPlay(url: "speedDown")
            case .maintain:
                print("maintain")
                audioPlay(url: "maintain")
            case .notMatched: break
        }

        // UIの更新
        DispatchQueue.main.async {
            self.calorieLabel.text = String(self.getCurrentCalorieBurned())
   
            // 時速の計算結果をlabelに反映
            var speedText = String(currentSpeed)
            if currentSpeed < 0 { speedText = "計測不能" }
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
    }
    
    /* 現在の位置でMapを更新
     * @param coordinate 現在位置 CLLocationCoordinate2D
     */
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        // 表示領域を作成
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, self.latDist, self.lonDist)
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

    
    /** addOverlayした際に呼ばれるデリゲートメソッド. */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // rendererを生成.
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        myPolyLineRendere.lineWidth = 2.5 // 線の太さを指定.
        myPolyLineRendere.strokeColor = UIColor.red // 線の色を指定.
        
        return myPolyLineRendere
    }

    
    
}







