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

    var myInfo: RealmDataSet? = nil

    
    @IBOutlet weak var workTypeLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = myInfo?.date

        workTypeLabel.text = myInfo?.workType == "directionRun" ? "ランニング" : "ウォーキング"
        calorieLabel.text = myInfo?.calorie
        distanceLabel.text = myInfo?.distance
        timeLabel.text = myInfo?.time
        speedLabel.text = myInfo?.speed
    }

    @IBAction func barButtonAction(_ sender: Any) {
        UIAlertController.presentActionSheet()
    }
    



}
