//
//  SettingCell.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/21.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

class SettingCell: UITableViewCell {
    
    
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var settingValueLabel: UILabel!
    

    
}



//        imageView = UIImageView(frame: CGRect(x:0, y:0, width: frame.width, height: frame.height))
//        imageView?.image = defaultImage
//
//        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height / 2))
//        textLabel?.text = "nil"
//        textLabel?.textAlignment = .center
//        textLabel?.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
//        textLabel?.textColor = UIColor.white
//
//        self.contentView.addSubview(imageView!)
//        self.contentView.addSubview(textLabel!)



