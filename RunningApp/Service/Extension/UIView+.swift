//
//  UIView+.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/24.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    enum BorderType {
        case Top
        case Left
        case Right
        case Bottom
    }
    /** UIViewにボーダをつける
     * @param aTypes - ボーダをつける面リスト[.Top, .Left, .Right, .Bottom]
     * @param aWidth - ボーダの太さ
     * @param aColor - ボーダカラー
     */
    func addBorder(types aTypes: [BorderType], width aWidth: CGFloat = 1.0, color aColor: UIColor) {
        for type in aTypes {
            let border = CALayer()
            border.backgroundColor = aColor.cgColor
            switch type {
            case .Top :
                border.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: self.frame.size.width,
                    height: aWidth
                )
            case .Left :
                border.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: aWidth,
                    height: self.frame.size.height
                )
            case .Right :
                border.frame = CGRect(
                    x: self.frame.size.width,
                    y: 0,
                    width: aWidth,
                    height: self.frame.size.height
                )
            case .Bottom :
                border.frame = CGRect(
                    x: 0,
                    y: self.frame.size.height,
                    width: self.frame.size.width,
                    height: aWidth
                )
            }
            self.layer.addSublayer(border)
        }
    }
    
    func addBorder(color: UIColor = UIColor.black, width: CGFloat = 0.5) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func addShadow(_ color: UIColor = UIColor.black, opacity: Float = 1.0, radius: CGFloat = 10.0 ,_ offset: CGSize = CGSize.zero) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
}

