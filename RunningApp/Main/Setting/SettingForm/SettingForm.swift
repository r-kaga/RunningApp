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

        let gradient = Gradiate(frame: self.view.frame)
        self.view.layer.addSublayer(gradient.setUpGradiate())
//        gradient.animateGradient()

        self.view.bringSubview(toFront: logoImageView)
        self.view.bringSubview(toFront: SettingCategoryLabel)
        self.view.bringSubview(toFront: textField)
        self.view.bringSubview(toFront: settingButton)
        self.view.bringSubview(toFront: closeButton)
        
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
