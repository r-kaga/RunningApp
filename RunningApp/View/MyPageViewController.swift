
import Foundation
import UIKit
import RealmSwift

protocol MyPageProtocol: class {
    func reload()
    func setNavigationTitle(title: String)
}

extension MyPageViewController: MyPageProtocol {
    func reload() {
        tableView.reloadData()
    }
    
    func setNavigationTitle(title: String) {
        navigationItem.title = title
    }
}

class MyPageViewController: UIViewController {
    
    private(set) var presenter: MyPagePresenterProtocol!

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
        
        presenter = MyPagePresenter(view: self)
    }
    
    func reloadData() {
        
    }
    
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.headerItem.count
    }

    /** cellの数を設定 */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch Section(rawValue: section) {
        case .some(.MyInfo):
            return presenter.myInfo.count
        case .none:
            return 0
        }
    }

    
    /** cellの生成 */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myPageCell") as! MyPageCell
        
        cell.backgroundColor = AppColor.backgroundColor
        cell.dateLabel.textColor = .gray
        cell.timeLabel.textColor = .black
        cell.distanceLabel.textColor = .black
        
        let item = presenter.myInfo[indexPath.row]
        cell.dateLabel.text = item.date
        cell.timeLabel.text = item.time
        cell.distanceLabel.text = item.distance + "km"
        
        /* セレクトされた時に何もしない */
        cell.selectionStyle = .none
        
        return cell
    }
    
    /** cellが選択された時 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let infoDetail = UIStoryboard(name: "infoDetailViewController", bundle: nil).instantiateInitialViewController() as! infoDetailViewController
        infoDetail.myInfo = presenter.myInfo[indexPath.row]
        infoDetail.delegate = self
        
        navigationController?.pushViewController(infoDetail, animated: true)
    }
    
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
    
    /** tableView表示された時 */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        self.loading?.close()
    }
    
}
