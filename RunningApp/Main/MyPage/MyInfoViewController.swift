

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
    
    enum Section: Int {
        case MyInfo = 0
    }
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "MyPage"
        self.view.backgroundColor = AppSize.backgroundColor
    }

    private func setupTableView() {

        tableView = UITableView(frame: CGRect(x: 0, y: AppSize.statusBarAndNavigationBarHeight + 40 + 15, width: AppSize.width, height: AppSize.height - (AppSize.statusBarAndNavigationBarHeight + AppSize.tabBarHeight + 40)), style: .grouped)
        tableView.backgroundColor = AppSize.backgroundColor
//        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(UINib(nibName: "MyPageCell", bundle: nil), forCellReuseIdentifier: "myPageCell")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
//        tableView.sectionIndexColor = .black
//        tableView.separatorInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)

        let realm = try! Realm()
        myInfo = RealmDataSet.shared.getAllData()

        guard !myInfo.isEmpty else {
            setupNoDate()
            return
        }

        tableView.refreshControl = refreshControl
        self.view.addSubview(tableView)

    }
    
    /** Pull Action Reload method */
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //        let newHotel = Hotels(name: "Montage Laguna Beach", place: "California south")
        //        hotels.append(newHotel)
        //        hotels.sort() { $0.name < $1.place }
        self.tableView.reloadData()
        self.tableView.refreshControl?.endRefreshing()
    }

    private func setupNoDate() {
        let noDateView = NoDateView(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height / 2.5))
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
//        return self.myInfo.count
        switch Section(rawValue: section) {
            case .some(.MyInfo):
                return myInfo.count
            case .none:
                return 0
        }
    }

    /** cellの生成 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell") as! MyPageCell
//        cell.frame = CGRect(x: 0, y: 0, width: AppSize.width, height: 100)
//        cell.layer.cornerRadius = 10.0
//        cell.clipsToBounds = true
        cell.backgroundColor = AppSize.backgroundColor
        cell.dateLabel.textColor = .gray
        cell.timeLabel.textColor = .black
        cell.distanceLabel.textColor = .black

        let item = self.myInfo[indexPath.row]
        cell.dateLabel.text = item.date
        cell.timeLabel.text = item.time
        cell.distanceLabel.text = item.distance + "km"

        /* セレクトされた時に何もしない */
        cell.selectionStyle = .none

        return cell
    }

    /*+ hearderを設定 */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerItem[0]
    }
//    /** hearderのViewを設定 */
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
//        headerView.backgroundColor = AppSize.backgroundColor
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height / 2))
//        label.text = self.headerItem[section]
//        label.textColor = .black
//        headerView.addSubview(label)
//        return headerView
//    }

 
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




