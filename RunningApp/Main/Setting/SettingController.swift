//
//  SettingController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/01.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

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


class SettingController: UIViewController, UITableViewDelegate {
    

    private var headerItem = ["self monitoring"]
    
    private var tableItem = [ 0 : [ "type": "weight", "unit" : "Kg", "image" : "assignment", "descriptino" : "カロリー計算で使用します" ],
                             1 : [ "type": "height", "unit" : "cm", "image" : "assignment", "descriptino" : "カロリー計算で使用します" ],
                             2 : [ "type": Const.PUSH_TIME, "unit" : "時", "image" : "pushTime", "descriptino" : "指定した時間にリマインドします"],
    ]

    private var tableTitle = [ "weight", "height", Const.PUSH_TIME ]
    
//    enum tableItem {
//
//        mutating func setType(indexPath: Int) {
//            switch indexPath {
//                case 1:
//                    return tableItem.weight
//                case 2:
//                    return tableItem.height
//                case 3:
//                    return tableItem.pushTime
//                default:
//                    return
//            }
//        }
//
//        static var count: Int {
//          return 3
//        }
//
//
//        enum weight: String {
//            case unit = "Kg"
//            case image = "pushTime"
//        }
//
//        enum height: String {
//            case unit = "cm"
//            case image = "pushTime"
//        }
//
//        enum pushTime: String {
//            case unit = "時"
//            case image = "pushTime"
//        }
//
//    }
    
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting"
        
//        let gradient = Gradiate(frame: self.view.frame)
//        self.view.layer.addSublayer(gradient.setUpGradiate())
//        gradient.animateGradient()

        tableView = UITableView(frame: self.view.frame, style: .grouped)
		tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .black
        tableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.sectionIndexColor = .black
        
        /* cellの上下に出来る横線を消す。高さがゼロのUIViewで上書き */
//        tableView.tableFooterView = UIView()
//        tableView.rowHeight = UITableViewAutomaticDimension

        self.view.addSubview(tableView)
    }
    
    
    private func presentSettingForm(path: Int) {

        guard let type = Const.SettingType(rawValue: path) else { return }
        
        let form = UIStoryboard(name: "SettingForm", bundle: nil).instantiateInitialViewController() as! SettingForm
        form.type = type
        form.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.present(form, animated: true, completion: {
//                blur.removeFromSuperview()
            })
        })
//        form.transition(from: <#T##UIViewController#>, to: <#T##UIViewController#>, duration: <#T##TimeInterval#>, options: ., animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)

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

    
}


extension SettingController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.headerItem.count
//        return SettingController.tableItem.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableTitle.count
//        return SettingController.tableItem.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
        cell.frame = CGRect(x: 0, y: 0, width: AppSize.width, height: 60)

        guard let item = self.tableItem[indexPath.row] else { return cell }
        
        cell.titleLabel.text = item["type"]
        cell.descriptionLabel.text = item["descriptino"]
        cell.imageCell.image = UIImage(named: item["image"]!)!
        
        if let value = UserDefaults.standard.string(forKey: item["type"]!) {
//            cell.detailTextLabel?.text = value + TableUnit[indexPath.section][indexPath.row + 1]
            cell.settingValueLabel.text = value + item["unit"]!
        
            if Const.PUSH_TIME == item["type"] {
                print("setLocalPushTime")
                Utility.setLocalPushTime(setTime: Int(value)!)
            }
        }
        cell.backgroundColor = .black
        
        /* セレクトされた時に何もしない */
        cell.selectionStyle = .none

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.headerItem[0]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.presentSettingForm(path: indexPath.row)
    }

    
}
