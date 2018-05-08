
import Foundation
import UIKit
import MapKit

protocol RunManageViewProtocol {
    
}

class RunManageViewController: UIViewController, RunManageViewProtocol {
    
    private(set) var presenter: RunManagePresenterProtocol!
    
    private var pin: MKPointAnnotation?
    
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


