
import UIKit
import RealmSwift

protocol HomeDelegate: class {
    func dateUpdate()
}

extension HomeViewController: HomeDelegate {
    func dateUpdate() {
        self.loadView()
    }
}

class HomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var ressultOutlet: UIView!
    @IBOutlet weak var distanceCharts: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var darkFillView: UIView!
    @IBOutlet weak var firstRoundButton: UIButton!
    @IBOutlet weak var secondRoundButton: UIButton!

    // 初回表示かどうか.アプリ立ち上げ時のみLoadingを表示
    var isFirstAppear: Bool = true
    var loading = Loading.make()
    
    private var latestData: Results<RealmDataSet> = RealmDataSet.shared.getAllData()

    var resultOutletHeight: CGFloat {
        return AppSize.height - (self.distanceCharts.frame.maxY + 100 + AppSize.tabBarHeight + 20)
    }
    
    let interactor = Interactor()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        self.view.backgroundColor = AppSize.backgroundColor
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isFirstAppear {
            loading?.startLoading()
            self.isFirstAppear = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.loading?.close()
            })
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        setupCollectionView()
        setupTogglerButton()
    }
    
    
    
    private func setupCollectionView() {
        
        guard !latestData.isEmpty else {
            setupNoDate(date: true)
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        //        layout.itemSize = CGSize(width: AppSize.width, height: ressultOutlet.frame.height)
        layout.itemSize = CGSize(width: AppSize.width, height: resultOutletHeight)
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        
        //        layout.headerReferenceSize = CGSize(width: 5, height: AppSize.height / 5) // セクション毎のヘッダーサイズ.
        
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: AppSize.width,
                                                            height: layout.itemSize.height), collectionViewLayout: layout)
        
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        //        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppSize.backgroundColor
        
        collectionView.removeFromSuperview()
        self.ressultOutlet.addSubview(collectionView)
    }

    
    /**  No Date Viewの表示 */
    private func setupNoDate(date: Bool) {
        guard date else { return }
        
        distanceCharts.isHidden = true
        ressultOutlet.isHidden = true
        
        let noDateView = NoDateView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 100, height: AppSize.height / 2.5))
        noDateView.center = self.view.center
        self.view.addSubview(noDateView)
    }
    
    /** toggleButtonのsetup */
    private func setupTogglerButton() {
        self.darkFillView.layer.cornerRadius = self.darkFillView.frame.width / 2
        self.firstRoundButton.layer.cornerRadius = self.firstRoundButton.frame.width / 2
        self.secondRoundButton.layer.cornerRadius = self.secondRoundButton.frame.width / 2
        
        self.firstRoundButton.alpha = 0.0
        self.secondRoundButton.alpha = 0.0
        
        firstRoundButton.layer.cornerRadius = 10.0
        secondRoundButton.layer.cornerRadius = 10.0
    }


    /** Buttonの開閉 */
    @IBAction func toggleMenu(_ sender: Any) {
        if darkFillView.transform == .identity {
            
            self.firstRoundButton.transform = CGAffineTransform(translationX: 0, y: 30)
            self.secondRoundButton.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.7, animations: {
                self.darkFillView.transform = CGAffineTransform(scaleX: 25, y: 10)
                self.menuView.transform = CGAffineTransform(translationX: 0, y: -20)
                self.toggleButton.transform = CGAffineTransform(rotationAngle: self.radians(180))
            }) { _ in
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.toggleButtonStatus()
                    self.firstRoundButton.transform = .identity
                    self.secondRoundButton.transform = .identity
                    
                })
                
            }
        } else {
            
            UIView.animate(withDuration: 0.7, animations: {
                self.darkFillView.transform = .identity
                self.menuView.transform = .identity
                self.toggleButton.transform = .identity
                self.toggleButtonStatus()
                self.firstRoundButton.transform = CGAffineTransform(rotationAngle: self.radians(180))
                self.secondRoundButton.transform = CGAffineTransform(rotationAngle: self.radians(180))
            })
        }
        
    }
    
    /** CGAffineTransform(rotationAngle)に渡す値の変換 */
    func radians(_ degress: Double) -> CGFloat {
        return CGFloat(degress * .pi / degress)
    }
    
    /** ボタンの開閉 */
    func toggleButtonStatus() {
        let alpha: CGFloat = firstRoundButton.alpha == 0.0 ? 1.0 : 0.0
        firstRoundButton.alpha = alpha
        secondRoundButton.alpha = alpha
    }
    
    /** fitness画面の表示 */
    func onSender(_ path: Int) {
        let sb = UIStoryboard(name: "WorkController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
        sb.interactor = interactor
        sb.transitioningDelegate = self
        WorkController.homeDelegate = self
        
        self.present(sb, animated: true, completion: nil)
    }
    
    @IBAction func runningRoundButton(_ sender: Any) {
        self.onSender(Const.WorkType.running.rawValue)
    }
    
    @IBAction func walkingRoundButton(_ sender: Any) {
        self.onSender(Const.WorkType.wallking.rawValue)
    }
    

}


/** collectionViewセットアップ */
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /* Cellが選択時 */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

    /* Cellに値を設定 */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath) as! HomeCollectionViewCell
        
        let data = latestData[indexPath.row]
        cell.carorieLabel.text = data.calorie
        cell.distanceLabel.text = data.distance
        cell.endTimeLabel.text = data.date
        cell.speedLabel.text = data.speed
        cell.timeLabel.text = data.time

        return cell
    }


    /* Cellの総数 */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }


}


/** PullCloseモーダルのセットアップ */
extension HomeViewController: UIViewControllerTransitioningDelegate {
    
    /** PullModalの表示 */
    func onPullModalShow() {
        let sb = UIStoryboard(name: "ModalViewController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
        sb.interactor = interactor
        sb.transitioningDelegate = self
        present(sb, animated: true, completion: nil)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
}





