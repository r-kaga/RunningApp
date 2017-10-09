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
    
    
    private var TableTitle = [ ["self information", "weight", "height"],
                              ["Monitoring", Const.PUSH_TIME, ],
    ]
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting"
        
        tableView = UITableView(frame: self.view.frame, style: .grouped)
		tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .gray
        self.view.addSubview(tableView)
    }
    
    
    private func presentSettingForm(path: Int) {
        guard let type = Const.SettingType(rawValue: path) else { return }

        let form = UIStoryboard(name: "SettingForm", bundle: nil).instantiateInitialViewController() as! SettingForm
        form.type = type
        form.delegate = self
//        form.modalPresentationStyle = .overCurrentContext
        present(form, animated: true, completion: nil)
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
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = self.TableTitle[indexPath.section][indexPath.row + 1]
        if let value = UserDefaults.standard.string(forKey: self.TableTitle[indexPath.section][indexPath.row + 1]) {
            cell.detailTextLabel?.text = value
            cell.detailTextLabel?.textColor = .black
            if Const.PUSH_TIME == self.TableTitle[indexPath.section][indexPath.row + 1] {
                Utility.setLocalPushTime(setTime: Int(value)!)
            }
        }
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.TableTitle[section][0]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.presentSettingForm(path: indexPath.row)
    }

    
}
