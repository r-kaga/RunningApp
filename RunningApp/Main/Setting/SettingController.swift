

import Foundation
import UIKit

protocol SettingDelegate: class {
    func reload()
}

extension SettingController: SettingDelegate {
    func reload() {
        self.tableView.reloadData()
    }
}


class SettingController: UIViewController {
    
    private var headerItem = ["self monitoring"]
    
    private var tableItem = [ 0 : [ "type": "weight", "unit" : "Kg", "image" : "assignment", "descriptino" : "カロリー計算で使用します" ],
                             1 : [ "type": "height", "unit" : "cm", "image" : "assignment", "descriptino" : "カロリー計算で使用します" ],
                             2 : [ "type": Const.PUSH_TIME, "unit" : "時", "image" : "pushTime", "descriptino" : "指定した時間にリマインドします"],
    ]

    private var tableTitle = [ "weight", "height", Const.PUSH_TIME ]

    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting"
        setupTableView()
    }
    
    /** tableViewのセットアップ */
    private func setupTableView() {
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.backgroundColor = AppSize.backgroundColor
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.sectionIndexColor = .black
        tableView.separatorInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        /* cellの上下に出来る横線を消す。高さがゼロのUIViewで上書き */
        //        tableView.tableFooterView = UIView()
        //        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.view.addSubview(tableView)
    }
    
    /** Formの表示
     *  @param path -> Int - 押されたCellのIndexPath
     */
    private func presentSettingForm(path: IndexPath) {
        guard let type = Const.SettingType(rawValue: path.row) else { return }
        
        let form = UIStoryboard(name: "SettingForm", bundle: nil).instantiateInitialViewController() as! SettingForm
        form.type = type
        form.delegate = self

        present(form, animated: false)
    }
    
}


extension SettingController: UITableViewDelegate {
    
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


extension SettingController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerItem.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
        cell.frame = CGRect(x: 0, y: 0, width: AppSize.width, height: 60)

        guard let item = self.tableItem[indexPath.row] else { return cell }
        
        cell.titleLabel.text = item["type"]
        cell.descriptionLabel.text = item["descriptino"]
        cell.imageCell.image = UIImage(named: item["image"]!)!
        
        if let value = UserDefaults.standard.string(forKey: item["type"]!) {
            cell.settingValueLabel.text = value + item["unit"]!
            if Const.PUSH_TIME == item["type"] {
                Utility.setLocalPushTime(setTime: Int(value)!)
            }
        }
        cell.backgroundColor = .white
        
        /* セレクトされた時に何もしない */
        cell.selectionStyle = .none

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerItem[0]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.presentSettingForm(path: indexPath)
    }

    
}
