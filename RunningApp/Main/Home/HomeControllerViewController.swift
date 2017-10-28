//
//  HomeControllerViewController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/26.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import RealmSwift

class HomeControllerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var totalDistance: TotalDistanceView!
    @IBOutlet weak var ressultOutlet: UIView!
    @IBOutlet weak var collectionOutlet: UIView!
    
    
    
    let interactor = Interactor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Home"

        setUpResultView()
        self.collectionOutlet.addSubview(self.layout())

    }
    
    
    private func setUpResultView() {

        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: ressultOutlet.frame.width, height: ressultOutlet.frame.height))
        scrollView.backgroundColor = UIColor.black
        scrollView.contentSize = CGSize(width: ressultOutlet.frame.width, height: ressultOutlet.frame.height) // 中身の大きさを設定
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self

        
        let realm = try! Realm()
        let latestData = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        
        guard !latestData.isEmpty else { return }
        
        let Latestlabel = UILabel(frame: CGRect(x: AppSize.width / 2 - 100,
                                                y: 0,
                                                width: 200,
                                                height: 20))
        Latestlabel.text = "Latest Date"
        Latestlabel.textColor = .white
        Latestlabel.textAlignment = .center
        scrollView.addSubview(Latestlabel)

        let view = resultView(frame: CGRect(x: 15,
                                            y: Latestlabel.frame.maxY + 5,
                                            width: ressultOutlet.frame.width - 30,
                                            height: ressultOutlet.frame.height - (Latestlabel.frame.maxY + 5))
        )
        
        view.setValueToResultView(dateTime: latestData[0].date,
                                  timeValue: latestData[0].time,
                                  distance: latestData[0].distance,
                                  speed: latestData[0].speed,
                                  calorie: latestData[0].calorie
        )
        view.typeImageView.image = UIImage(named: latestData[0].workType)!
        scrollView.addSubview(view)
        
        guard latestData.count >= 2 else { return }
        
        let secondlabel = UILabel(frame: CGRect(x: (AppSize.width + AppSize.width / 2) - 100,
                                                y: 0,
                                                width: 200,
                                                height: 20))
        
        secondlabel.text = "Seconde Date"
        secondlabel.textColor = .white
        secondlabel.textAlignment = .center
        scrollView.contentSize.width += ressultOutlet.frame.width
        scrollView.addSubview(secondlabel)
        
        let second = resultView(frame: CGRect(x: ressultOutlet.frame.width + 15,
                                              y: secondlabel.frame.maxY + 5,
                                              width: ressultOutlet.frame.width - 30,
                                              height: ressultOutlet.frame.height - (secondlabel.frame.maxY + 5)))
        second.setValueToResultView(dateTime: latestData[1].date,
                                    timeValue: latestData[1].time,
                                    distance: latestData[1].distance,
                                    speed: latestData[1].speed,
                                    calorie: latestData[1].calorie
        )
        second.typeImageView.image = UIImage(named: latestData[1].workType)!
        scrollView.addSubview(second)

        
        
        guard latestData.count >= 3 else { return }
        
        let thirdlabel = UILabel(frame: CGRect(x: (AppSize.width * 2 + AppSize.width / 2) - 100,
                                               y: 0,
                                               width: 200,
                                               height: 20))
        
        //        thirdlabel.center = CGPoint(x: (third.frame.maxX - third.frame.width / 2), y: 0)
        thirdlabel.text = "third Date"
        thirdlabel.textColor = .white
        thirdlabel.textAlignment = .center
        scrollView.addSubview(thirdlabel)
        
        let third = resultView(frame: CGRect(x: (ressultOutlet.frame.width * 2) + 15,
                                             y: thirdlabel.frame.maxY + 5,
                                             width: ressultOutlet.frame.width - 30,
                                             height: ressultOutlet.frame.height - (thirdlabel.frame.maxY + 5))
        )
        
        third.setValueToResultView(dateTime: latestData[2].date,
                                   timeValue: latestData[2].time,
                                   distance: latestData[2].distance,
                                   speed: latestData[2].speed,
                                   calorie: latestData[2].calorie
        )
        third.typeImageView.image = UIImage(named: latestData[2].workType)!
        
        scrollView.contentSize.width += ressultOutlet.frame.width
        scrollView.addSubview(third)

        
        self.ressultOutlet.addSubview(scrollView)
        
        
        /** トータルディスタンスView */
        let realmDate = realm.objects(RealmDataSet.self)
        var distanceDate = 0
        realmDate.forEach { value in
            distanceDate = Int(value.distance)!
        }
        totalDistance.totalDistanceLabel.text = String(distanceDate)
        totalDistance.descriptionLabel.text = Utility.getDescrition(distance: distanceDate)
        
    }
    
    
    private func layout() -> UICollectionView {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: AppSize.width / 2, height: collectionOutlet.frame.height)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        layout.scrollDirection = .horizontal
        
        // セクション毎のヘッダーサイズ.
        //        layout.headerReferenceSize = CGSize(width: 5, height: AppSize.height / 5)
        
        let collectionView = UICollectionView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: AppSize.width,
                                                         height: layout.itemSize.height), collectionViewLayout: layout)
        collectionView.register(HomeCustomCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }
    

    
    
    func onSender(_ path: Int) {
        
        let sb = UIStoryboard(name: "WorkController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
        sb.interactor = interactor
        sb.transitioningDelegate = self
        WorkController.workType = Utility.pathConvertWorkType(path: path).0
        
        self.present(sb, animated: true, completion: nil)
        
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}




extension HomeControllerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /*
     Cellが選択時
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSender(indexPath.row)
    }
    
    
    /*
     Cellに値を設定
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: HomeCustomCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MyCell",
            for: indexPath) as! HomeCustomCell
        
        
        let path = indexPath[1]
        let type = Utility.pathConvertWorkType(path: path)
        let cellImage = UIImage(named: type.1)!
        cell.imageView?.image = cellImage
        cell.textLabel?.text = type.1
        
        return cell
    }
    
    
    /*
     Cellの総数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    
}





extension HomeControllerViewController: UIViewControllerTransitioningDelegate {
    
    func onPullModalShow() {
        let sb = UIStoryboard(name: "ModalViewController", bundle: nil).instantiateInitialViewController() as! ModalNavigationController
        sb.interactor = interactor
        sb.transitioningDelegate = self
        //        sb.
        AppDelegate.getTopMostViewController().present(sb, animated: true, completion: nil)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    
}





