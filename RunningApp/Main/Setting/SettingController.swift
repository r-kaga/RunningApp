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
    
    
    private var TableTitle = [ ["self information", "weight", "height", Const.PUSH_TIME],
//                              ["Monitoring", , ],
    ]
    
    private var TableUnit = [
        [ "self information", "Kg", "cm", "時" ]
    ]
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting"
        

        tableView = UITableView(frame: self.view.frame, style: .grouped)
		tableView.backgroundColor = .black
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

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let blur = UIVisualEffectView(frame: self.view.frame)
        blur.effect = UIBlurEffect(style: .dark)
        self.view.addSubview(blur)

        let transion: CATransition = CATransition()
        transion.duration = 0.3
        transion.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transion.type = kCATransitionReveal
        transion.subtype = kCATransitionFromLeft
        self.view.window?.layer.add(transion, forKey: nil)
        
        guard let type = Const.SettingType(rawValue: path) else { return }
        
        let form = UIStoryboard(name: "SettingForm", bundle: nil).instantiateInitialViewController() as! SettingForm
        form.type = type
        form.delegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.present(form, animated: true, completion: {
                blur.removeFromSuperview()
            })
        })
//        form.transition(from: <#T##UIViewController#>, to: <#T##UIViewController#>, duration: <#T##TimeInterval#>, options: ., animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)

    }
    
}


extension SettingController: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.TableTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TableTitle[section].count - 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell") as! SettingCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
        cell.frame = CGRect(x: 0, y: 0, width: AppSize.width, height: 60)

        cell.titleLabel.text = self.TableTitle[indexPath.section][indexPath.row + 1]
        cell.descriptionLabel.text = "設定項目の説明が入ります"
        
        if let value = UserDefaults.standard.string(forKey: self.TableTitle[indexPath.section][indexPath.row + 1]) {
            cell.detailTextLabel?.text = value + TableUnit[indexPath.section][indexPath.row + 1]
            cell.settingValueLabel.text = value + TableUnit[indexPath.section][indexPath.row + 1]
        
            if Const.PUSH_TIME == self.TableTitle[indexPath.section][indexPath.row + 1] {
                Utility.setLocalPushTime(setTime: Int(value)!)
            }
        }
        cell.backgroundColor = .black
        
        /* セレクトされた時に何もしない */
        cell.selectionStyle = .none

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.TableTitle[section][0]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.presentSettingForm(path: indexPath.row)
    }

    
}
