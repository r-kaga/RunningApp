
import Foundation
import UIKit
import MapKit
import CoreLocation
import AVFoundation
import Lottie

enum currentSpeedType: String {
    case up
    case down
    case maintain
    case notMatched
}

protocol RunManageViewProtocol: AVAudioPlayerDelegate, RoutingProtocol {
    var latDist: CLLocationDistance { get }
    var lonDist: CLLocationDistance { get }
    var startTimeDate: Date? { get }
    var audioPlayer: AVAudioPlayer! { get }
    func audioPlay(url: String)
}

class RunManageViewController: UIViewController, RunManageViewProtocol {
    
    private(set) var presenter: RunManagePresenterProtocol!
    
    private var pin: MKPointAnnotation?
    private var locationManager: CLLocationManager!

    // 縮尺
    var latDist: CLLocationDistance = 500
    var lonDist: CLLocationDistance = 500
    var startTimeDate: Date?
    
    weak private var timer: Timer?

    var audioPlayer: AVAudioPlayer!

    /* 現在地を表示するMapKitを生成 */
    private lazy var mapView: MKMapView = {
        // MapViewの生成
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    private lazy var cardView: UIStackView = {
//        let view = UIView(frame: .zero)
//        view.backgroundColor = .white
//        view.layer.cornerRadius = 10.0
//        view.clipsToBounds = true
       
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.addArrangedSubview(animationView)
        stackView.addArrangedSubview(bottomCardViewOutlet)
        
        return stackView
    }()
    
    private lazy var animationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "deer")
        animationView.backgroundColor = .white
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        animationView.play()
        return animationView
    }()
    
    private lazy var bottomCardViewOutlet: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        
        let stackView = UIStackView(frame: .zero)
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.addArrangedSubview(calorieLabel)
        stackView.addArrangedSubview(speedLabel)
        stackView.addArrangedSubview(stopWatchLabel)
        return view
    }()
    
    private lazy var calorieLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "0.0"
        return label
    }()

    private lazy var speedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "計測不可"
        return label
    }()
    
    private lazy var stopWatchLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.text = "00:00:00"
        return label
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
        activateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startTimer()
    }
    
    private func setupView() {
        view.backgroundColor = AppColor.appConceptColor
        view.addSubview(closeButton)
        view.addSubview(cardView)
        view.addSubview(calorieLabel)
        view.addSubview(speedLabel)
        view.addSubview(stopWatchLabel)
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
    
    /** 音声を再生 */
    func audioPlay(url: String) {
        guard url != currentSpeedType.notMatched.rawValue else { return }
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
            self.stopWatchLabel.text = self.presenter.getElapsedTime(startTimeDate: self.startTimeDate ?? Date())
        }
    }
    
    /* タイマーの終了時処理 */
    private func stopTimer() {
        if timer != nil{
            timer?.invalidate()
            stopWatchLabel.text = "00::00:00"
        }
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
        
        let path: String
        switch presenter.checkCurrentSpeedIsPaceable(currentSpeed: currentSpeed, pace: pace) {
        case .up:
            print("speedUp")
            path = currentSpeedType.up.rawValue
        case .down:
            print("speedDown")
            path = currentSpeedType.down.rawValue
        case .maintain:
            print("maintain")
            path = currentSpeedType.maintain.rawValue
        case .notMatched:
            path = currentSpeedType.notMatched.rawValue
        }
        audioPlay(url: path)
        
        // UIの更新
        DispatchQueue.main.async {
            self.calorieLabel.text = String(self.presenter.getCurrentCalorieBurned(startTimeDate: self.startTimeDate ?? Date()))
            
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


