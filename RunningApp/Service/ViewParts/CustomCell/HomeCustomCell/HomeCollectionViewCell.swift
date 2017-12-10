//
//  HomeCollectionViewCell.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/12/09.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var carorieLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 7.5
        cardView.clipsToBounds = true
    }

}
