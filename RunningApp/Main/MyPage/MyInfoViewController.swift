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

extension MyInfoViewController: MyPageDelegate {
    func reload() {
        self.tableView.reloadData()
    }

    func setNavigationTitle(title: String) {
        navigationItem.title = title
    }
}


class MyInfoViewController: UIViewController, UIScrollViewDelegate {
    
    //    var loading: Loading?
    private var tableView: UITableView!
    
    private let headerItem = [ "MyInfo" ]
    private var myInfo: Results<RealmDataSet>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "MyPage"
    }

    private func setupTableView() {

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: 15))
        label.textAlignment = .center
        label.center = CGPoint(x: AppSize.width / 2, y:  AppSize.statusBarAndNavigationBarHeight + 15 + 40)
        label.text = "Your Fitness All Date"
        label.textColor = .white
        self.view.addSubview(label)

        tableView = UITableView(frame: CGRect(x: 15, y: label.frame.maxY, width: AppSize.width - 30, height: AppSize.height - (AppSize.height / 3)), style: .plain)
        tableView.backgroundColor = .black
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(UINib(nibName: "MyPageCell", bundle: nil), forCellReuseIdentifier: "myPageCell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.sectionIndexColor = .black
        tableView.sectionIndexBackgroundColor = .black
        tableView.sectionIndexTrackingBackgroundColor = .black

        let realm = try! Realm()
        myInfo = realm.objects(RealmDataSet.self).sorted(byKeyPath: "id", ascending: false)

        guard !myInfo.isEmpty else {
            setupNoDate()
            return
        }

        self.view.addSubview(tableView)

    }


    private func setupNoDate() {
        let noDateView = NoDateView(frame: CGRect(x: 0, y: 0, width: AppSize.width - 100, height: AppSize.height / 2.5))
        noDateView.center = self.view.center
        self.view.addSubview(noDateView)
    }
    
}



extension MyInfoViewController: UITableViewDelegate {

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


extension MyInfoViewController: UITableViewDataSource {

    /** sectionの数を規定 */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerItem.count
    }

    /** cellの数を設定 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myInfo.count
    }

    /** cellの生成 */
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

    /** hearderを設定*/
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerItem[0]
    }

    /** cellが選択された時 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        let infoDetail = UIStoryboard(name: "infoDetailViewController", bundle: nil).instantiateInitialViewController() as! infoDetailViewController
        infoDetail.myInfo = myInfo[indexPath.row]
        infoDetail.delegate = self

        self.navigationController?.pushViewController(infoDetail, animated: true)
    }

    /** tableView表示された時 */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        self.loading?.close()
    }


}




