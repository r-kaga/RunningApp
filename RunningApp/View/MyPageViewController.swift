
import Foundation
import UIKit

protocol MyPageViewControllerProtocol {
    func reloadData()
}

class MyPageViewController: UIViewController, MyPageViewControllerProtocol {
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
//        tableView.delegate
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    func reloadData() {
        <#code#>
    }
    
}
