
import UIKit
import Charts


protocol HomeViewProtocol {
    func startRunning()
    func moreShowRunData()
    func updateLatestChartsDate()
}

class HomeViewController: UIViewController, HomeViewProtocol {
    
    private(set) var presenter: HomePresenterProtocol!

    lazy private var chartViewOutlet: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 20, height: AppSize.height / 5))
        view.center = CGPoint(x: AppSize.width / 2, y: AppSize.statusBarAndNavigationBarHeight + view.frame.height / 2 + 10)
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    lazy private var distanceChartView: LineChartView = {
        let chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 20, height: AppSize.height / 5))
        chartView.chartDescription?.text = ""
        chartView.backgroundColor = .white
        chartView.xAxis.enabled = false
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        return chartView
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: AppSize.width / 2, height: AppSize.height / 3)
        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 10.0
//        layout.minimumInteritemSpacing = 5.0
//        layout.sectionInset = UIEdgeInsetsMake(0, 2.0, 0, 2.0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "RunDataInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RunDataInfoCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var moreShowButton: UIButton = {
        let btn = TappableButton(frame: .zero)
        btn.backgroundColor = .clear
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(AppColor.appConceptColor, for: .normal)
        btn.setTitle("もっと見る", for: .normal)
        btn.addTarget(self, action: #selector(moreShowRunData), for: .touchUpInside)
        return btn
    }()

    lazy private var startRunButton: TappableButton = {
        let btn = TappableButton(frame: .zero)
        btn.setTitle("ランニングを始める", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = AppColor.appConceptColor
        btn.layer.cornerRadius = 10.0
        btn.clipsToBounds = true
        btn.addTarget(self, action: #selector(startRunning), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter = HomePresenter(view: self)
        updateLatestChartsDate()
    }
    
    @objc func startRunning() {
        presenter.transition(self, route: .startRun, routingType: .present, observer: self, selector: #selector(runDataUpdated))
    }
    
    @objc func runDataUpdated() {
        collectionView.reloadData()
        updateLatestChartsDate()
    }
    
    @objc func moreShowRunData() {
        presenter.transition(self, route: .moreRunData, routingType: .push, observer: self, selector: #selector(runDataUpdated))
    }
    
    private var emptyView: EmptyView?
    func updateLatestChartsDate() {
        var chartsShouldShowFlg: Bool
        if presenter.latestData.isEmpty {
            chartsShouldShowFlg = true
            emptyView = EmptyView(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.contentViewHeight / 3))
            emptyView?.center = view.center
            view.addSubview(emptyView!)
            view.bringSubview(toFront: startRunButton)
            
        } else {
            emptyView?.removeFromSuperview()
            chartsShouldShowFlg = false
        }
        distanceChartView.isHidden = chartsShouldShowFlg
        moreShowButton.isHidden = chartsShouldShowFlg
        
        var entries = [BarChartDataEntry]()
        var count = 0.0

        let roop = presenter.latestData.count >= 15 ? 15 : presenter.latestData.count
        for i in 0..<roop {
            entries.append(BarChartDataEntry(x: count, y: Double(presenter.latestData[i].distance)!))
            count += 0.1
        }
        let set = LineChartDataSet(values: entries, label: "走行距離")
        distanceChartView.data = LineChartData(dataSet: set)
    }

    private func setupView() {
        navigationItem.title = "Home"
        view.backgroundColor = AppColor.backgroundColor
        chartViewOutlet.addSubview(distanceChartView)
        view.addSubview(chartViewOutlet)
        view.addSubview(collectionView)
        view.addSubview(moreShowButton)
        view.addSubview(startRunButton)
        activateConstraints()
    }

    private func activateConstraints() {
        moreShowButton.translatesAutoresizingMaskIntoConstraints = false
        moreShowButton.topAnchor.constraint(equalTo: distanceChartView.bottomAnchor, constant: 15).isActive = true
        moreShowButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        moreShowButton.sizeToFit()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: AppSize.height / 3).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        collectionView.topAnchor.constraint(equalTo: moreShowButton.bottomAnchor, constant: 0).isActive = true
    
        startRunButton.translatesAutoresizingMaskIntoConstraints = false
//        // iPhone X
//        if UIScreen.main.nativeBounds.height == 2436 {
//            startRunButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(50 + AppSize.tabBarHeight)).isActive = true
//        } else {
//            startRunButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(30 + AppSize.tabBarHeight)).isActive = true
//        }
        startRunButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10).isActive = true
        startRunButton.widthAnchor.constraint(equalToConstant: AppSize.width - 50).isActive = true
        startRunButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startRunButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.showRunDataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RunDataInfoCollectionViewCell", for: indexPath) as! RunDataInfoCollectionViewCell
        cell.setRunData(presenter.latestData[indexPath.row])
        return cell
    }

//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let width: CGFloat = view.frame.width / 3 - 2
//        let height: CGFloat = width
//        print("collectionViewLayout")
//        return CGSize(width: width, height: height)
//    }
    
}
