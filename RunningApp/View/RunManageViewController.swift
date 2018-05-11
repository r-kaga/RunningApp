
import Foundation
import UIKit
import MapKit
import CoreLocation

protocol RunManageViewProtocol {
    
}

class RunManageViewController: UIViewController, RunManageViewProtocol {
    
    private(set) var presenter: RunManagePresenterProtocol!
    
    private var pin: MKPointAnnotation?
    private var locationManager: CLLocationManager!

    // 縮尺
    private var latDist: CLLocationDistance = 500
    private var lonDist: CLLocationDistance = 500
    
    /* 現在地を表示するMapKitを生成 */
    lazy private var mapView: MKMapView = {
        // MapViewの生成
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(mapView)
        presenter = RunManagePresenter(view: self)
        setupLocationManager()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mapView.widthAnchor.constraint(equalToConstant: AppSize.width).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: AppSize.height / 2).isActive = true
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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


