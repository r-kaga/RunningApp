//
//import UIKit
//import RealmSwift
//import Charts
//
//
//class HomeViewController: UIViewController, ChartViewDelegate {
//
//    @IBOutlet weak var ressultOutlet: UIView!
//    @IBOutlet weak var distanceCharts: UIView!
//    @IBOutlet weak var menuView: UIView!
//    @IBOutlet weak var firstRoundButton: UIButton!
//
//    private var latestData: Results<RealmDataSet> = RealmDataSet.getAllData()
//
//    private var resultOutletHeight: CGFloat {
//        return AppSize.height - (self.distanceCharts.frame.maxY + 100 + AppSize.tabBarHeight + 20)
//    }
//    
//    private var collectionView: UICollectionView?
//    private var noDateView: NoDateView?
//    private var chartView: LineChartView?
//    private let interactor = Interactor()
//
//    static var shouldDateUpdate = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationItem.title = "Home"
//        view.backgroundColor = AppSize.backgroundColor
//        setupCollectionView()
//        distanceChatsSetUp()
//        setupNoDate()
//        
//        firstRoundButton.layer.cornerRadius = 25
//        firstRoundButton.clipsToBounds = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        if HomeViewController.shouldDateUpdate {
//            defer {
//                HomeViewController.shouldDateUpdate = false
//            }
//            
//            if latestData.isEmpty {
//                noDateView?.isHidden = false
//            } else {
//                noDateView?.isHidden = true
//            }
//            
//            collectionView?.reloadData()
//            updateLatestChartsDate()
//        }
//
//    }
//    
//    private func setupCollectionView() {
//
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: AppSize.width, height: resultOutletHeight)
//        
//        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        layout.minimumLineSpacing = 1.0
//        layout.minimumInteritemSpacing = 1.0
//        layout.scrollDirection = .horizontal
//        
//        collectionView = UICollectionView(frame: CGRect(x: 0,
//                                                            y: 0,
//                                                            width: AppSize.width,
//                                                            height: layout.itemSize.height), collectionViewLayout: layout)
//        
//        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
//        collectionView?.register(nib, forCellWithReuseIdentifier: "cell")
//        
//        collectionView?.showsVerticalScrollIndicator = false
//        collectionView?.showsHorizontalScrollIndicator = false
//        collectionView?.isPagingEnabled = true
//        collectionView?.bounces = false
//        collectionView?.delegate = self
//        collectionView?.dataSource = self
//        collectionView?.backgroundColor = AppSize.backgroundColor
//        
//        collectionView?.removeFromSuperview()
//        self.ressultOutlet.addSubview(collectionView!)
//    }
//
//    /**  No Date Viewの表示 */
//    private func setupNoDate() {
//        noDateView = NoDateView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 100, height: AppSize.height / 2.5))
//        noDateView?.center = self.view.center
//        self.view.addSubview(noDateView!)
//        
//        if !latestData.isEmpty {
//            noDateView?.isHidden = true
//        }
//    }
//    
//    
//    /** 初期設定 */
//    private func distanceChatsSetUp() {
//
//        distanceCharts.layer.cornerRadius = 5.0
//        distanceCharts.clipsToBounds = true
//        
//        distanceCharts.addBorder(color: .gray, width: 0.5)
//        distanceCharts.backgroundColor = .clear
//
//        let rect = CGRect(x: 0, y: 0 , width: AppSize.width - 20, height: 160)
//        
//        chartView = LineChartView(frame: rect)
//        chartView?.chartDescription?.text = ""
//        chartView?.xAxis.enabled = false
//        chartView?.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//
//        updateLatestChartsDate()
//    
//        distanceCharts.addSubview(chartView!)
//    }
//    
//    private func updateLatestChartsDate() {
//        
//        var chartsShouldShowFlg: Bool
//        if latestData.isEmpty {
//            chartsShouldShowFlg = true
//        } else {
//            chartsShouldShowFlg = false
//        }
//        distanceCharts.isHidden = chartsShouldShowFlg
//
//        var entries = [BarChartDataEntry]()
//        var count = 0.0
//        
//        let roop = latestData.count >= 15 ? 15 : latestData.count
//        for i in 0..<roop {
//            entries.append(BarChartDataEntry(x: count, y: Double(latestData[i].distance)!))
//            count += 0.1
//        }
//        let set = LineChartDataSet(values: entries, label: "走行距離")
//        chartView?.data = LineChartData(dataSet: set)
//    }
//
//    /** fitness画面の表示 */
//    func onSender() {
//        let sb = UIStoryboard(name: "WorkController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
//        sb.interactor = interactor
//        sb.transitioningDelegate = self
//        
//        self.present(sb, animated: true, completion: nil)
//    }
//    
//    @IBAction func runningRoundButton(_ sender: Any) {
//        self.onSender()
//    }
//
//
//}
//
//
///** collectionViewセットアップ */
//extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    /* Cellが選択時 */
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
//
//    /* Cellに値を設定 */
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "cell",
//            for: indexPath) as! HomeCollectionViewCell
//        
//        let data = latestData[indexPath.row]
//        cell.carorieLabel.text = data.calorie
//        cell.distanceLabel.text = data.distance
//        cell.endTimeLabel.text = data.date
//        cell.speedLabel.text = data.speed
//        cell.timeLabel.text = data.time
//
//        return cell
//    }
//
//
//    /* Cellの総数 */
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return latestData.count > 3 ? 3 : latestData.count
//    }
//
//}
//
//
///** PullCloseモーダルのセットアップ */
//extension HomeViewController: UIViewControllerTransitioningDelegate {
//    
//    /** PullModalの表示 */
//    func onPullModalShow() {
//        let sb = UIStoryboard(name: "ModalViewController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
//        sb.interactor = interactor
//        sb.transitioningDelegate = self
//        present(sb, animated: true, completion: nil)
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return DismissAnimator()
//    }
//    
//    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return interactor.hasStarted ? interactor : nil
//    }
//    
//}
//
//
//
//
//
