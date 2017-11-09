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
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var SettingCategoryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var settingButton: ActionAcceptButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBAction func ScreenTapAction(_ sender: Any) {
        self.textField.endEditing(true)
    }
    
    var type: Const.SettingType?
    var categoryName: String!
    weak var delegate: SettingDelegate?

//    var pastelView: PastelView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSetup()
        
        let picker = UIPickerView(frame: CGRect(x: 0,
                                              y: AppSize.height - AppSize.height / 3,
                                              width: AppSize.width,
                                              height: AppSize.height / 3))
        self.view.addSubview(picker)
        
    }

    private func initSetup() {
        
        textField.delegate = self

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
        
        
        let gradient = Gradiate(frame: self.view.frame)
        self.view.layer.addSublayer(gradient.setUpGradiate())
        gradient.animateGradient()
        
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


    private func validateSetting(value: String) throws -> Int  {
        guard !value.isEmpty else { throw Const.ErrorType.empty }
        guard let value = Int(value) else { throw Const.ErrorType.notInteger }
        
        return value
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
    
    
}

extension SettingForm: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



