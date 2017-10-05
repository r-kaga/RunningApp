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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true

        textField.delegate = self
    }
    
    
    @IBAction func settingButton(_ sender: Any) {
        
        
        guard let text = self.textField.text, !text.isEmpty
            else {
                let alert = UIAlertController(title: "からです", message: "からです", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    print("OK")
                }))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        guard let weight = Int(text) else {
            let alert = UIAlertController(title: "数値を入れて下さい", message: "数値です", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                print("OK")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.dismiss(animated: true, completion: {
            UserDefaults.standard.set(String(weight), forKey: "weight")
        })
        
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
