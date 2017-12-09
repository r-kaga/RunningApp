//
//  HomeControllerViewController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/26.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

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
    
    var resultOutletHeight: CGFloat {
        return AppSize.height - (self.distanceCharts.frame.maxY + 100 + AppSize.tabBarHeight + 20)
    }
    
    let interactor = Interactor()
    
//    var collectionView: UICollectionView = {
//        let collection = UICollectionView()
//    }()

    var collectionView: UICollectionView!
    
    private func setupCollectionView() {
    
        let realm = try! Realm()
        let latestData = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)

        guard !latestData.isEmpty else {
            setupNoDate(date: true)
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: AppSize.width, height: ressultOutlet.frame.height)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal

        //        layout.headerReferenceSize = CGSize(width: 5, height: AppSize.height / 5) // セクション毎のヘッダーサイズ.

        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: AppSize.width,
                                                         height: layout.itemSize.height), collectionViewLayout: layout)
        let nib: UINib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
//        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")

        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppSize.backgroundColor

        self.ressultOutlet.addSubview(collectionView)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Home"
        self.view.backgroundColor = AppSize.backgroundColor

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
        
        setupCollectionView()
        setupTogglerButton()
    }
    
  
    /** resultViewのsetup */
    private func setUpResultView() {

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height))
        scrollView.backgroundColor = AppSize.backgroundColor
        scrollView.contentSize = CGSize(width: AppSize.width, height: ressultOutlet.frame.height) // 中身の大きさを設定
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        
        defer {
            self.ressultOutlet.addSubview(scrollView)
        }
 
        let realm = try! Realm()
        
        let latestData = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        print(latestData)
        
        guard !latestData.isEmpty else {
            setupNoDate(date: true)
            return
        }
        
        let Latestlabel = UILabel(frame: CGRect(x: AppSize.width / 2 - 100,
                                                y: 0,
                                                width: 200,
                                                height: 20))
        Latestlabel.text = "Latest Date"
        Latestlabel.textColor = .gray
        Latestlabel.textAlignment = .center
        scrollView.addSubview(Latestlabel)

        let view = resultView(frame: CGRect(x: 15,
                                            y: 5,
                                            width: AppSize.width - 30,
                                            height: resultOutletHeight - (Latestlabel.frame.maxY + 5))

        )
        view.center = CGPoint(x: AppSize.width / 2, y: Latestlabel.frame.maxY + view.frame.height / 2 + 5)
        
        view.setValueToResultView(dateTime: latestData[0].date,
                                  timeValue: latestData[0].time,
                                  distance: latestData[0].distance,
                                  speed: latestData[0].speed,
                                  calorie: latestData[0].calorie
        )
        view.typeImageView.image = UIImage(named: latestData[0].workType)!
        view.addBorder(color: .gray, width: 0.5)
        
//        view.indexPath = latestData[0].id
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(Home.longPressed(_:)))
//        view.addGestureRecognizer(longPress)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Home.tapGesture(_:)))
//        view.addGestureRecognizer(tapGesture)
        
        scrollView.addSubview(view)
        
        guard latestData.count >= 2 else { return }
        
        let secondlabel = UILabel(frame: CGRect(x: (AppSize.width + AppSize.width / 2) - 100,
                                                y: 0,
                                                width: 200,
                                                height: 20))
        
        secondlabel.text = "Seconde Date"
        secondlabel.textColor = .gray
        secondlabel.textAlignment = .center
        scrollView.contentSize.width += AppSize.width
        scrollView.addSubview(secondlabel)
        
        let second = resultView(frame: CGRect(x: AppSize.width + 15,
                                              y: secondlabel.frame.maxY + 5,
                                              width: AppSize.width - 30,
                                              height: resultOutletHeight - (secondlabel.frame.maxY + 5)))
        second.setValueToResultView(dateTime: latestData[1].date,
                                    timeValue: latestData[1].time,
                                    distance: latestData[1].distance,
                                    speed: latestData[1].speed,
                                    calorie: latestData[1].calorie
        )
        second.typeImageView.image = UIImage(named: latestData[1].workType)!
        second.addBorder(color: .gray, width: 0.5)
        
//        second.indexPath = latestData[1].id
//        second.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(Home.longPressed(_:))))
//        second.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Home.tapGesture(_:))))
        
        scrollView.addSubview(second)
        
        guard latestData.count >= 3 else { return }
        
        let thirdlabel = UILabel(frame: CGRect(x: (AppSize.width * 2 + AppSize.width / 2) - 100,
                                               y: 0,
                                               width: 200,
                                               height: 20))
        
        //        thirdlabel.center = CGPoint(x: (third.frame.maxX - third.frame.width / 2), y: 0)
        thirdlabel.text = "third Date"
        thirdlabel.textColor = .gray
        thirdlabel.textAlignment = .center
        scrollView.addSubview(thirdlabel)
        
        let third = resultView(frame: CGRect(x: (AppSize.width * 2) + 15,
                                             y: thirdlabel.frame.maxY + 5,
                                             width: AppSize.width - 30,
                                             height: resultOutletHeight - (thirdlabel.frame.maxY + 5))
        )
        
        third.setValueToResultView(dateTime: latestData[2].date,
                                   timeValue: latestData[2].time,
                                   distance: latestData[2].distance,
                                   speed: latestData[2].speed,
                                   calorie: latestData[2].calorie
        )
        third.typeImageView.image = UIImage(named: latestData[2].workType)!
        third.addBorder(color: .gray, width: 0.5)
        
//        third.indexPath = latestData[2].id
//        third.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(Home.longPressed(_:))))
//        third.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(Home.tapGesture(_:))))
        
        scrollView.contentSize.width += AppSize.width
        scrollView.addSubview(third)

        self.ressultOutlet.addSubview(scrollView)
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
        WorkController.workType = Utility.pathConvertWorkType(path: path).0
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
//        self.onSender(indexPath.row)
    }

    /* Cellに値を設定 */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath)
        
//        cell.backgroundColor = {
//            switch indexPath.row {
//                case 1:
//                    return .black
//                case 2:
//                    return .blue
//                case 3:
//                    return .red
//                default:
//                    return .yellow
//            }
//        }()
        
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





