//
//  SettingForm.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit
import Pastel


class SettingForm: UIViewController {
    
//    @IBOutlet weak var formView: UIView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var SettingCategoryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var settingButton: ActionAcceptButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    let gradient = CAGradientLayer()
    var gradientSet = [[CGColor]]()
    var currentGradient: Int = 0
    
//    let gradientOne  = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
//    let gradientTwo  = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
//    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    let gradientTwo  = UIColor(red: 83/255, green: 105/255, blue: 118/255, alpha: 1).cgColor
    let gradientOne = UIColor(red: 41/255, green: 46/255, blue: 73/255, alpha: 1).cgColor
    let gradientThree  = UIColor(red: 187/255, green: 210/255, blue: 197/255, alpha: 1).cgColor

//    let gradientOne  = UIColor(red: 83/255, green: 105/255, blue: 108/255, alpha: 1).cgColor
//    let gradientThree = UIColor(red: 41/255, green: 46/255, blue: 73/255, alpha: 1).cgColor
    
//    let gradientOne  = UIColor(red: 43/255, green: 88/255, blue: 118/255, alpha: 1).cgColor
//    let gradientThree = UIColor(red: 78/255, green: 67/255, blue: 118/255, alpha: 1).cgColor
    
    var type: Const.SettingType?
    var categoryName: String!
    weak var delegate: SettingDelegate?

//    var pastelView: PastelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let type = type else { return }
        switch type {
            case .weight:
                categoryName = "weight"
            case .height:
                categoryName = "height"
            case .pushTime:
                categoryName = Const.PUSH_TIME
        }
        SettingCategoryLabel.text = categoryName
        
        textField.delegate = self
        
//        pastelView = PastelView(frame: view.bounds)
//        pastelView.startPastelPoint = .bottomLeft
//        pastelView.endPastelPoint = .topRight
//        pastelView.animationDuration = 3.0
//
//        pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
//                              UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
//                              UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
//                              UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
//                              UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
//                              UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
//                              UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
//
//        pastelView.startAnimation()
//
//        view.insertSubview(pastelView, at: 0)

        gradientSet.append([gradientOne, gradientTwo])
        gradientSet.append([gradientTwo, gradientThree])
        gradientSet.append([gradientThree, gradientOne])

        gradient.frame = self.view.bounds
        gradient.colors = gradientSet[currentGradient]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)

        // 色が切り替わる地点
//        let locations:[NSNumber] = [
//            0.100, 0.250, 0.375, 0.500, 0.625, 0.750, 0.900
//        ]
//        gradient.locations = locations

        gradient.drawsAsynchronously = true
        self.view.layer.addSublayer(gradient)

        animateGradient()

        self.view.bringSubview(toFront: logoImageView)
        self.view.bringSubview(toFront: SettingCategoryLabel)
        self.view.bringSubview(toFront: textField)
        self.view.bringSubview(toFront: settingButton)
        self.view.bringSubview(toFront: closeButton)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//    }

    private func animateGradient() {
        if currentGradient < gradientSet.count - 1 {
            currentGradient += 1
        } else {
            currentGradient = 0
        }

        let gradientChangeAnimation = CABasicAnimation(keyPath: "colors")
        gradientChangeAnimation.duration = 4.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.toValue = gradientSet[currentGradient]
        gradientChangeAnimation.fillMode = kCAFillModeForwards
        gradientChangeAnimation.isRemovedOnCompletion = false
        gradientChangeAnimation.autoreverses = true
        gradient.add(gradientChangeAnimation, forKey: "colorChange")
    }
    
    @IBAction func settingButton(_ sender: Any) {

        do {
            let value = try self.validateSetting(value: textField.text!)

            self.dismiss(animated: true, completion: {
                UserDefaults.standard.set(String(value), forKey: self.categoryName)
                self.delegate?.reload()
            })
            
        } catch Const.ErrorType.empty {
            let alert = UIAlertController(title: "値が入力されていません", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                print("OK")
            }))
            self.present(alert, animated: true, completion: nil)

        } catch Const.ErrorType.notInteger {
            let alert = UIAlertController(title: "数値が入力されていません", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                print("OK")
            }))
            self.present(alert, animated: true, completion: nil)
        } catch {
            print("unexpected")
        }
        
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
    
    
    private func validateSetting(value: String) throws -> Int  {
        guard !value.isEmpty else {
            throw Const.ErrorType.empty
        }
        
        guard let value = Int(value) else {
            throw Const.ErrorType.notInteger
        }
        return value

    }
    
    
}

extension SettingForm: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


//
//extension SettingForm: CAAnimationDelegate {
//    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            gradient.colors = gradientSet[currentGradient]
//            animateGradient()
//        }
//    }
//}
//
