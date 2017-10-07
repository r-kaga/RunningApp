//
//  SettingForm.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/04.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


class SettingForm: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var SettingCategoryLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var type: Const.SettingType?
    var categoryName: String!
    weak var delegate: SettingDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let type = type else { return }
        switch type {
            case .weight:
                categoryName = "weight"
            case .height:
                categoryName = "height"
        }
        SettingCategoryLabel.text = categoryName
        
        textField.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        tabBarController?.tabBar.isHidden = true
        MainTabBarViewController.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        tabBarController?.tabBar.isHidden = false
        MainTabBarViewController.tabBar.isHidden = false

    }
    
    
    @IBAction func settingButton(_ sender: Any) {

        do {
            let value = try self.validateSetting(value: textField.text!)

            self.dismiss(animated: true, completion: {
                UserDefaults.standard.set(String(value), forKey: self.categoryName)
                self.delegate?.reload()
            })
        } catch Const.ErrorType.empty {
            let alert = UIAlertController(title: "からです", message: "からです", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                print("OK")
            }))
            self.present(alert, animated: true, completion: nil)

        } catch Const.ErrorType.notInteger {
            let alert = UIAlertController(title: "数値を入れて下さい", message: "数値です", preferredStyle: .alert)
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
        
//        do {
        guard !value.isEmpty else {
            throw Const.ErrorType.empty
        }
        
        guard let value = Int(value) else {
            throw Const.ErrorType.notInteger
        }
        return value
//
//        } catch Const.ErrorType.empty {
//
//            let alert = UIAlertController(title: "からです", message: "からです", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                print("OK")
//            }))
//            self.present(alert, animated: true, completion: nil)
//
//        } catch Const.ErrorType.notInteger {
//            let alert = UIAlertController(title: "数値を入れて下さい", message: "数値です", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                print("OK")
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
        
    }
    
    
}

extension SettingForm: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


class SettingButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10.0
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
}


