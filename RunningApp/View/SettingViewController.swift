

import Foundation
import UIKit


protocol SettingViewProtocol {
    
}

class SettingViewController: UIViewController, SettingViewProtocol {
    
    private(set) var presenter: SettingPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame)
        tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.backgroundColor = AppColor.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.bounces = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SettingPresenter(view: self)
        setupView()
        activateConstraints()
    }
    
    
    private func setupView() {
        navigationItem.title = "Setting"
        view.backgroundColor = AppColor.backgroundColor
        view.addSubview(tableView)
    }
    
    private func activateConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    /** Formの表示
     *  @param path -> Int - 押されたCellのIndexPath
     */
    private func presentSettingForm(path: IndexPath) {
        guard let type = SettingType(rawValue: path.row) else { return }
        let form = UIStoryboard(name: "SettingForm", bundle: nil).instantiateInitialViewController() as! SettingForm
        form.type = type
//        form.delegate = self
        present(form, animated: false)
    }
    
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerItem.count
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 1:
//            return headerItem.selfMonitoring.rawValue
//        default:
//            return headerItem.selfMonitoring.rawValue
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
        cell.selectionStyle = .none /* セレクトされた時に何もしない */

        var unit: String
        (cell.titleLabel.text, cell.descriptionLabel.text, unit, cell.imageCell.image) = {
            return tableItem.getTableItem(indexPath: indexPath.row)
        }()
        
        if let value = UserDefaults.standard.string(forKey: cell.titleLabel.text!) {
            cell.settingValueLabel.text = value + unit
            if Const.PUSH_TIME == cell.titleLabel.text {
                Utility.setLocalPushTime(setTime: Int(value)!)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.presentSettingForm(path: indexPath)
    }
    
    
}
