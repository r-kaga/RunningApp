
import UIKit
import Charts
import RealmSwift

protocol HomeViewProtocol {
    func startRunning()
}

class HomeViewController: UIViewController {
    
    private(set) var presenter: HomePresenterProtocol!
    private var latestData: Results<RealmDataSet> = RealmDataSet.getAllData()

    lazy private var chartViewOutlet: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 20, height: 160))
        view.center = CGPoint(x: AppSize.width / 2, y: AppSize.statusBarAndNavigationBarHeight + view.frame.height / 2 + 10)
        view.backgroundColor = .white
        return view
    }()
    
    lazy private var distanceChartView: LineChartView = {
        let chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 20, height: 160))
        chartView.chartDescription?.text = ""
        chartView.xAxis.enabled = false
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        return chartView
    }()
    
//    /** 初期設定 */
//    private func distanceChatsSetUp() {
//        distanceCharts.layer.cornerRadius = 5.0
//        distanceCharts.clipsToBounds = true
//
//        distanceCharts.addBorder(color: .gray, width: 0.5)
//        distanceCharts.backgroundColor = .clear
//    }
    
    private func updateLatestChartsDate() {

        var chartsShouldShowFlg: Bool
        if latestData.isEmpty {
            chartsShouldShowFlg = true
        } else {
            chartsShouldShowFlg = false
        }
        distanceChartView.isHidden = chartsShouldShowFlg

        var entries = [BarChartDataEntry]()
        var count = 0.0

        let roop = latestData.count >= 15 ? 15 : latestData.count
        for i in 0..<roop {
            entries.append(BarChartDataEntry(x: count, y: Double(latestData[i].distance)!))
            count += 0.1
        }
        let set = LineChartDataSet(values: entries, label: "走行距離")
        distanceChartView.data = LineChartData(dataSet: set)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter = HomePresenter(view: self)
        updateLatestChartsDate()
    }
    
    private func setupView() {
        navigationItem.title = "Home"
        view.backgroundColor = AppColor.backgroundColor
        chartViewOutlet.addSubview(distanceChartView)
        view.addSubview(chartViewOutlet)
    }

}


extension HomeViewController: HomeViewProtocol {
    
    func startRunning() {
        
    }
    
}
