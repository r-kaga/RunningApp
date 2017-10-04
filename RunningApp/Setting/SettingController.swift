//
//  SettingController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/01.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


class SettingController: UIViewController, UITableViewDelegate {
    
    
    var TableTitle = [ ["menuTitle01", "title01", "title02"],
                       ["menuTitle02", "title03", "title04"],
    ]
    
    var TableSubtitle = [ ["", "subtitle02", "subtitle03"],
                          ["","subtitle05", "subtitle06"],

    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting"
        
        
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
		tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .black
        self.view.addSubview(tableView)
    }
    
    
    enum SettingType: Int {
        case weight = 0
    }
    
    
    func changeSetting(path: Int) {
        guard let type = SettingType(rawValue: path) else { return }

        let form = SettingForm()
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
        cell.detailTextLabel?.text = self.TableSubtitle[indexPath.section][indexPath.row + 1]
        cell.backgroundColor = .black
        cell.textLabel?.textColor = . white
        cell.detailTextLabel?.textColor = .white
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.TableTitle[section][0]
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.changeSetting(path: indexPath.row)
    }

    
}
