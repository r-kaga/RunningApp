//
//
//import Foundation
//import UIKit
//
//protocol SettingDelegate: class {
//    func reload()
//}
//
//extension SettingController: SettingDelegate {
//    func reload() {
//        print("reload")
//        self.tableView.reloadData()
//    }
//}
//
//
//enum headerItem: String {
//    case selfMonitoring = "self monitoring"
//    
//    static var count = 1
//    
//}
//
//
///* 設定項目
// */
//enum SettingType: Int {
//    case weight     = 0
//    case height
//    case pushTime
//    case pace
//
//    static let count: Int = {
//        var i = 0
//        while let _ = SettingType(rawValue: i) {
//            i = i + 1
//        }
//        return i
//    }()
//}
//
//
//enum tableItem {
//    
//    enum weight {
//        static var type: String {
//            return "weight"
//        }
//        static var unit: String {
//            return "Kg"
//        }
//        
//        static var descriptino: String {
//            return "カロリー計算で使用します"
//        }
//        
//        static var image: UIImage {
//            return UIImage(named: "assignment")!
//        }
//    }
//    enum height {
//        static var type: String {
//            return "height"
//        }
//        static var unit: String {
//            return "cm"
//        }
//        
//        static var descriptino: String {
//            return "カロリー計算で使用します"
//        }
//        
//        static var image: UIImage {
//            return UIImage(named: "assignment")!
//        }
//
//    }
//    enum pushTime {
//        static var type: String {
//            return Const.PUSH_TIME
//        }
//        static var unit: String {
//            return "時"
//        }
//        static var descriptino: String {
//            return "指定した時間にリマインドします"
//        }
//        
//        static var image: UIImage {
//            return UIImage(named: "pushTime")!
//        }
//
//    }
//    enum pace {
//        static var type: String {
//            return "pace"
//        }
//        static var unit: String {
//            return "Km/h"
//        }
//        static var descriptino: String {
//            return "理想のペースを設定します"
//        }
//        
//        static var image: UIImage {
//            return UIImage(named: "pushTime")!
//        }
//
//    }
//    
//}
//
//
//class SettingController: UIViewController {
//    
////    private var tableItem = [ [ "type": "weight", "unit" : "Kg", "image" : "assignment", "descriptino" : "カロリー計算で使用します" ],
////                             [ "type": "height", "unit" : "cm", "image" : "assignment", "descriptino" : "カロリー計算で使用します" ],
////                             [ "type": Const.PUSH_TIME, "unit" : "時", "image" : "pushTime", "descriptino" : "指定した時間にリマインドします"],
////                             [ "type": "Pace",   "unit" : "Km/h", "image" : "pushTime", "descriptino" : "理想のペースを設定します"],
////
////    ]
//
//    private var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        navigationItem.title = "Setting"
//        setupTableView()
//    }
//    
//    /** tableViewのセットアップ */
//    private func setupTableView() {
//        tableView = UITableView(frame: self.view.frame, style: .grouped)
//        tableView.backgroundColor = AppColor.backgroundColor
//        tableView.bounces = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorColor = .clear
//        tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "cell")
//        tableView.estimatedRowHeight = 60
//        tableView.rowHeight = 60
//        tableView.sectionIndexColor = .black
//        tableView.separatorInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
//        /* cellの上下に出来る横線を消す。高さがゼロのUIViewで上書き */
//        //        tableView.tableFooterView = UIView()
//        //        tableView.rowHeight = UITableViewAutomaticDimension
//        
//        self.view.addSubview(tableView)
//    }
//    
//    /** Formの表示
//     *  @param path -> Int - 押されたCellのIndexPath
//     */
//    private func presentSettingForm(path: IndexPath) {
//        guard let type = SettingType(rawValue: path.row) else { return }
//        
//        let form = UIStoryboard(name: "SettingForm", bundle: nil).instantiateInitialViewController() as! SettingForm
//        form.type = type
//        form.delegate = self
//
//        present(form, animated: false)
//    }
//    
//}
//
//
//extension SettingController: UITableViewDelegate {
//    
//    /*
//     * 各indexPathのcellがハイライトされた際に呼ばれます．
//     * あるcellがタップされた際は，didHighlight → didUnhighlight → willSelect → didSelectの順に呼び出されます．
//     * さらにその状態で別のcellがタップされた際は，didHighlight → didUnhighlight → willSelect → willDeselect → didDeselect → didSelectの順に呼び出されます．
//     */
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.contentView.touchStartAnimation()
//    }
//    
//    /*
//     * 各indexPathのcellがアンハイライトされた際に呼ばれます．
//     * 基本的にtableView(_:didHighlightRowAt:)が呼ばれた直後に呼ばれます．
//     */
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.contentView.touchEndAnimation()
//    }
//
//    
//}
//
//
//extension SettingController: UITableViewDataSource {
//    
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return headerItem.count
//    }
//    
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 1:
//            return headerItem.selfMonitoring.rawValue
//        default:
//            return headerItem.selfMonitoring.rawValue
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return SettingType.count
//    }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
//        cell.frame = CGRect(x: 0, y: 0, width: AppSize.width, height: 60)
//
//        var unit: String
//        (cell.titleLabel.text, cell.descriptionLabel.text, cell.imageCell.image, unit) = {
//            switch indexPath.row {
//                case 0:
//                    return (tableItem.weight.type, tableItem.weight.descriptino, tableItem.weight.image, tableItem.weight.unit)
//                case 1:
//                    return (tableItem.height.type, tableItem.height.descriptino, tableItem.height.image, tableItem.height.unit)
//                case 2:
//                    return (tableItem.pushTime.type, tableItem.pushTime.descriptino, tableItem.pushTime.image, tableItem.pushTime.unit)
//
//                case 3:
//                    return (tableItem.pace.type, tableItem.pace.descriptino, tableItem.pace.image, tableItem.pace.unit)
//
//                default:
//                    return (tableItem.weight.type, tableItem.weight.descriptino, tableItem.weight.image, tableItem.weight.unit)
//            }
//        }()
//
//        
//        if let value = UserDefaults.standard.string(forKey: cell.titleLabel.text!) {
//            cell.settingValueLabel.text = value + unit
//            if Const.PUSH_TIME == cell.titleLabel.text {
//                Utility.setLocalPushTime(setTime: Int(value)!)
//            }
//        }
//        cell.backgroundColor = .white
//        
//        /* セレクトされた時に何もしない */
//        cell.selectionStyle = .none
//
//        return cell
//    }
//    
//
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
//        self.presentSettingForm(path: indexPath)
//    }
//
//    
//}
