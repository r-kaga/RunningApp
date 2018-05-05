
import Foundation
import UIKit
import RealmSwift

protocol MyPageViewControllerProtocol {
    func reloadData()
}

class MyPageViewController: UIViewController, MyPageViewControllerProtocol {
    
    lazy private var myInfo: Results<RealmDataSet> = {
        return RealmDataSet.getAllData()
    }()
    
    lazy private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: AppSize.statusBarAndNavigationBarHeight, width: AppSize.width, height: AppSize.height - (AppSize.statusBarAndNavigationBarHeight + AppSize.tabBarHeight)), style: .plain)
        tableView.backgroundColor = AppColor.backgroundColor
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(UINib(nibName: "MyPageCell", bundle: nil), forCellReuseIdentifier: "myPageCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    /** Pull Action Reload method */
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    func reloadData() {
        
    }
    
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    /** cellの生成 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell") as! MyPageCell
        
        cell.backgroundColor = AppColor.backgroundColor
        cell.dateLabel.textColor = .gray
        cell.timeLabel.textColor = .black
        cell.distanceLabel.textColor = .black
        
        let item = myInfo[indexPath.row]
        cell.dateLabel.text = item.date
        cell.timeLabel.text = item.time
        cell.distanceLabel.text = item.distance + "km"
        
        /* セレクトされた時に何もしない */
        cell.selectionStyle = .none
        
        return cell
    }
    
}
