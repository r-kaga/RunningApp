
import Foundation
import UIKit
import MapKit
import CoreLocation
import AVFoundation

enum currentSpeedType {
    case up
    case down
    case maintain
    case notMatched
}

protocol RunManageViewProtocol {
    
}

class RunManageViewController: UIViewController, AVAudioPlayerDelegate, RunManageViewProtocol {
    
    private(set) var presenter: RunManagePresenterProtocol!
    
    private var pin: MKPointAnnotation?
    private var locationManager: CLLocationManager!

    // 縮尺
    private var latDist: CLLocationDistance = 500
    private var lonDist: CLLocationDistance = 500
    
    private var audioPlayer: AVAudioPlayer!

    weak private var timer: Timer?
    private var startTimeDate: Date!
    
    /* 現在地を表示するMapKitを生成 */
    private lazy var mapView: MKMapView = {
        // MapViewの生成
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var calorieLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    private lazy var speedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var stopWatchLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        view.addSubview(calorieLabel)
        view.addSubview(speedLabel)
        view.addSubview(stopWatchLabel)
        view.addSubview(mapView)
        
        presenter = RunManagePresenter(view: self)
        setupLocationManager()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTimer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: AppSize.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: AppSize.height / 2).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        calorieLabel.translatesAutoresizingMaskIntoConstraints = false
        calorieLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        calorieLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        calorieLabel.widthAnchor.constraint(equalToConstant: AppSize.width / 2).isActive = true
        calorieLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        speedLabel.topAnchor.constraint(equalTo: calorieLabel.bottomAnchor, constant: 30).isActive = true
        speedLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        speedLabel.widthAnchor.constraint(equalToConstant: AppSize.width / 2).isActive = true
        speedLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        stopWatchLabel.translatesAutoresizingMaskIntoConstraints = false
        stopWatchLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 30).isActive = true
        stopWatchLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        stopWatchLabel.widthAnchor.constraint(equalToConstant: AppSize.width / 2).isActive = true
        stopWatchLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    /** 現在のスピードと設定した理想のペースを比較する */
    private func checkCurrentSpeedIsPaceable(currentSpeed: Double, pace: Double) -> currentSpeedType {
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
    
}



extension RunManageViewController: CLLocationManagerDelegate {
    
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
        
//        guard self.isStarted else { return }
        
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


extension RunManageViewController: MKMapViewDelegate {
    
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


