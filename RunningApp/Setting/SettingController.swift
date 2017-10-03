//
//  SettingController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/01.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

class SettingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var TableTitle = [ ["menuTitle01", "title01", "title02"],
                       ["menuTitle02", "title03", "title04"],
                       
                       ["menuTitle03", "menuTitle05", "menuTitle06"],
                       ["menuTitle04", "menuTitle07"]
    ]
    
    
    var TableSubtitle = [ ["", "subtitle02", "subtitle03"],
                          ["","subtitle05", "subtitle06"],
                          ["", "subtitle06", "subtitle07"],
                          ["", "subtitle08"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Setting"
        
        
        let tableView = UITableView(frame: self.view.frame, style: .grouped)
		tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    
    
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.TableTitle[section][0]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
}
