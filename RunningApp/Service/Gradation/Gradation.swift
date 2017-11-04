//
//  Gradation.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/11/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class GradationView: UIView {
    
    var gradientLayer: CAGradientLayer?
    
    @IBInspectable var topColor: UIColor = UIColor.white {
        didSet {
            setGradation()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.black {
        didSet {
            setGradation()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradation()
    }
    
    private func setGradation() {
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer!.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer!.frame.size = frame.size
        layer.addSublayer(gradientLayer!)
        layer.masksToBounds = true
    }
}
