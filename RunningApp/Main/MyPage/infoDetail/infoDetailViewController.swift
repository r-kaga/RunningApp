//
//  infoDetailViewController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/11/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import RealmSwift

class infoDetailViewController: UIViewController {

    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!

    var myInfo: RealmDataSet? = nil

    weak var delegate: MyPageDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = myInfo?.date
        navigationController?.navigationBar.topItem?.title = ""
    
        workTypeLabel.text = myInfo?.workType == "directionsRun" ? "ランニング" : "ウォーキング"
        calorieLabel.text = myInfo?.calorie
        distanceLabel.text = myInfo?.distance
        timeLabel.text = myInfo?.time
        speedLabel.text = myInfo?.speed
    }

    
    @IBAction func barButtonAction(_ sender: Any) {
        UIAlertController.presentActionSheet(deleteAction: delete)
    }
    
    
    private func delete() {
        let loading = Loading.make()
        loading?.startLoading()
        
        defer {
            loading?.close()
        }
        
        guard self.myInfo != nil else { return }
        let realm = try! Realm()
        
        try! realm.write() {
            realm.delete(self.myInfo!)
        }
        
        self.navigationController?.popViewController(animated: true)
        self.delegate?.reload()
    }
    



}
