//
//  SettingFormButton.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/10.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

class SettingButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
}
