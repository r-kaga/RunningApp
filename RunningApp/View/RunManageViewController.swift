
import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreMotion
import AVFoundation
import Lottie

enum currentSpeedType: String {
    case up
    case down
    case maintain
    case notMatched
}

protocol RunManageViewProtocol: AVAudioPlayerDelegate, RoutingProtocol, Notify {
    var latDist: CLLocationDistance { get }
    var lonDist: CLLocationDistance { get }
    var startTimeDate: Date? { get }
    var audioPlayer: AVAudioPlayer? { get }
    func audioPlay(url: currentSpeedType)
    var observer: Any { get }
    var selector: Selector { get }
    init(observer: Any, selector: Selector)
}

class RunManageViewController: UIViewController, RunManageViewProtocol {

    var observer: Any
    var selector: Selector
    
    required init(observer: Any, selector: Selector) {
        self.observer = observer
        self.selector = selector
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) var presenter: RunManagePresenterProtocol!
    
    private var pin: MKPointAnnotation?
    private var locationManager: CLLocationManager!
    
    private let pedometer = CMPedometer()

    // 縮尺
    var latDist: CLLocationDistance = 500
    var lonDist: CLLocationDistance = 500
    var startTimeDate: Date?
    
    var startPlace: CLLocation?
    var firstPin: MKPointAnnotation?
    
    weak private var timer: Timer?

    var audioPlayer: AVAudioPlayer?

    /* 現在地を表示するMapKitを生成 */
    private lazy var mapView: MKMapView = {
        // MapViewの生成
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var cardView: RunManageCardView = {
        let view = RunManageCardView(frame: .zero)
        view.endButton.addTarget(self, action: #selector(confirmWorkEndAlert), for: .touchUpInside)
        return view
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    @objc private func dismissView() {
        dismissView(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RunManagePresenter(view: self)
        setupView()
        setupLocationManager()
        setupPedometer()
        activateConstraints()
        
        addObserver(observer, selector: selector)
    }
    
    deinit {
        removeObserver(observer)
        audioPlayer = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTimer()
    }
    
    private func setupView() {
        view.backgroundColor = AppColor.appConceptColor
        view.addSubview(closeButton)
        view.addSubview(cardView)
        view.addSubview(mapView)
    }

    private func activateConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: AppSize.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: AppSize.height / 2).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        closeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 0).isActive = true
        cardView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        cardView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        cardView.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -20).isActive = true
    }
    
    /** 音声を再生 */
    func audioPlay(url: currentSpeedType) {
        guard url != .notMatched else { return }
        let audioPath = URL(fileURLWithPath: Bundle.main.path(forResource: url.rawValue, ofType:"mp3")!)
        
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
        audioPlayer?.delegate = self
        //        audioPlayer.prepareToPlay()
        audioPlayer?.play()
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
        cardView.animationView.play()
    }
    
    /* labelに経過時間を表示 */
    @objc func timerCounter() {
        DispatchQueue.main.async {
            self.cardView.elapsedTimeLabel.text = self.presenter.getElapsedTime(startTimeDate: self.startTimeDate ?? Date())
        }
    }
    
    /* タイマーの終了時処理 */
    private func stopTimer() {
        if timer != nil{
            timer?.invalidate()
            self.cardView.elapsedTimeLabel.text = "00::00:00"
        }
    }
    
    /** 計測終了確認アラート */
    @objc private func confirmWorkEndAlert() {
        let alert = UIAlertController(title: "計測を終了します", message: "終了してもよろしいですか?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.registWorkResult()
            self?.dismissModal()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    /** DBに登録 */
    private func registWorkResult() {
        presenter.registResults(view: cardView)
    }

    /** 歩数を取得するためのSetup */
    private func setupPedometer() {
        guard CMPedometer.isDistanceAvailable() else { return }
        self.pedometer.startUpdates(from: NSDate() as Date) { (data: CMPedometerData?, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data, let dis = data.distance?.doubleValue, error == nil
                    else { return }
                
                let distance = String(round( ( dis / 1000.0 ) * 100) / 100)
                self.cardView.distanceLabel.text = distance + "Km"
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
    
    /* Modalを閉じる */
    private func dismissModal() {
        self.timer?.invalidate()
        dismiss(animated: true, completion: { [presentingViewController] () -> Void in
            if self.pin != nil {
                self.mapView.removeAnnotation(self.pin!)
            }
            self.mapView.removeFromSuperview()
            self.notify()
            presentingViewController?.viewWillAppear(true)
        })
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
        
        firstPin = MKPointAnnotation() // ピンを生成.
        firstPin!.coordinate =  coordinate // 座標を設定.
        firstPin!.title = "開始位置" // タイトルを設定.
        mapView.addAnnotation(firstPin!)
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

//        let distance = startPlace?.distance(from: location)
//        print(distance)
//        print(distance! / 1000.0)
//        // 1000mを超える場合はキロメートで表示
//        let distanceText = distance! / 1000.0 > 1.0 ?
//            "\(floor(distance! / 1000.0)) Km"
//            :
//        "\(floor(distance!))m"
//        print(distanceText)

        self.setRegion(coordinate: location.coordinate) // Regionを作成.
        self.setPin(title: "現在地", coordinate: location.coordinate) // pinをセット
        
        //MARK: - ペースメーカー
        let currentSpeed = round((location.speed * 3.6) * 10) / 10
        var pace: Double = Const.defaulPaceSpeed
        if let value = UserDefaults.standard.object(forKey: "pace") as? Int {
            pace = Double(value)
        }
        
        let path = presenter.checkCurrentSpeedIsPaceable(currentSpeed: currentSpeed, pace: pace)
        audioPlay(url: path)
        
        // UIの更新
        DispatchQueue.main.async {
            self.cardView.calorieLabel.text = String(self.presenter.getCurrentCalorieBurned(startTimeDate: self.startTimeDate ?? Date()))
            var speedText = String(currentSpeed) // 時速の計算結果をlabelに反映
            if currentSpeed < 0 { speedText = "計測不能" }
            self.cardView.speedLabel.text = speedText
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


