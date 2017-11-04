//
//  MyPageViewController.swift
//  sampleUIViewApp
//
//  Created by 加賀谷諒 on 2017/07/16.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import RealmSwift


protocol MyPageDelegate: class {
    func reload()
    func setNavigationTitle(title: String)
}

extension MyPage: MyPageDelegate {
    func reload() {
        self.tableView.reloadData()
    }
    
    func setNavigationTitle(title: String) {
        navigationItem.title = title
    }
}


class MyPage: UIViewController, UIScrollViewDelegate {

    var loading: Loading?
    
    private var tableView: UITableView!
    
    private let headerItem = [ "MyInfo" ]
    private var myInfo: Results<RealmDataSet>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loading = Loading.make()
        self.loading?.startLoading()
        
        tableView = UITableView(frame: CGRect(x: 15, y: 0, width: AppSize.width - 30, height: AppSize.height), style: .grouped)
        tableView.backgroundColor = .black
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(UINib(nibName: "MyPageCell", bundle: nil), forCellReuseIdentifier: "myPageCell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.sectionIndexColor = .black

        let realm = try! Realm()
        myInfo = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
        
        print(type(of: myInfo[0]))
        
//        setupMyInfo()
        self.view.addSubview(tableView)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "MyPage"
    }
    
    
    /**  */
    private func setupMyInfo() {
//        Utility.showLoading()
        
        self.loading = Loading.make()
        self.loading?.startLoading()
        
        DispatchQueue.main.async {
            
            let scrollView = UIScrollView(frame: CGRect(x: 0,
                                                        y: AppSize.statusBarAndNavigationBarHeight,
                                                        width: AppSize.width,
                                                        height: AppSize.height))
            scrollView.backgroundColor = .clear
            scrollView.bounces = false
            scrollView.showsVerticalScrollIndicator = true
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.delegate = self
            
            let realm = try! Realm()
            let data = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)
            
            guard !data.isEmpty else {
                self.setupNoDate()
                return
            }
            
            var count: CGFloat = 0
            data.forEach { (value) in
                let view = resultView(frame: CGRect(x: 15,
                                                    y: 30 + (170 * count),
                                                    width: AppSize.width - 30,
                                                    height: 150))
                
                view.setValueToResultView(dateTime: value.date,
                                          timeValue: value.time,
                                          distance: value.distance,
                                          speed: value.speed,
                                          calorie: value.calorie)
                view.typeImageView.image = UIImage(named: value.workType)!
                view.tag = Int(value.id)
                
                
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MyPage.longPressed(_:)))
                view.addGestureRecognizer(longPress)
                
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyPage.tapGesture(_:)))
                view.addGestureRecognizer(tapGesture)
                
                scrollView.addSubview(view)
                
                count += 1
            }
            
            scrollView.contentSize = CGSize(width: AppSize.width, height: (170 * (count + 1) - 50)) // 中身の大きさを設定
            self.view.addSubview(scrollView)
            
            self.loading?.close()
        }
        
    }
    
    
    private func setupNoDate() {
        let noDateView = NoDateView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 100, height: AppSize.height / 2.5))
        noDateView.center = self.view.center
        self.view.addSubview(noDateView)
    }


}



extension MyPage: UITableViewDelegate {
    
    /*
     * 各indexPathのcellがハイライトされた際に呼ばれます．
     * あるcellがタップされた際は，didHighlight → didUnhighlight → willSelect → didSelectの順に呼び出されます．
     * さらにその状態で別のcellがタップされた際は，didHighlight → didUnhighlight → willSelect → willDeselect → didDeselect → didSelectの順に呼び出されます．
     */
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.touchStartAnimation()
    }

    /*
     * 各indexPathのcellがアンハイライトされた際に呼ばれます．
     * 基本的にtableView(_:didHighlightRowAt:)が呼ばれた直後に呼ばれます．
     */
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.touchEndAnimation()
    }

    
}


extension MyPage: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerItem.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell") as! MyPageCell
        cell.frame = CGRect(x: 15, y: 0, width: AppSize.width - 30, height: 60)
        cell.layer.cornerRadius = 10.0
        cell.clipsToBounds = true
        cell.backgroundColor = .black

        let item = self.myInfo[indexPath.row]
        cell.typeImageView?.image = UIImage(named: item.workType)!
        cell.dateLabel.text = item.date
        cell.timeLabel.text = item.time
        cell.distanceLabel.text = item.distance + "km"
        
//        cell.backgroundColor = .black        
        /* セレクトされた時に何もしない */
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerItem[0]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let infoDetail = UIStoryboard(name: "infoDetailViewController", bundle: nil).instantiateInitialViewController() as! infoDetailViewController
        infoDetail.myInfo = myInfo[indexPath.row]
        infoDetail.delegate = self
        
        self.navigationController?.pushViewController(infoDetail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.loading?.close()
    }
    
    
}






