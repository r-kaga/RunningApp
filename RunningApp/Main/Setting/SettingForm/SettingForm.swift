

import Foundation
import UIKit
import Pastel


class SettingForm: UIViewController, PickerDelegate {
    
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

    var settingValue = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSetup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [], animations: {
            self.view.transform = .identity
        })

    }

    private func initSetup() {
        
        textField.delegate = self

        guard let type = type else { return }
        switch type {
        case .weight:
            categoryName = "weight"
            
            var weightNum = [String]()
            for i in 40..<100 {
                weightNum.append(String(i))
            }
            settingValue = weightNum
            
        case .height:
            categoryName = "height"
            var heightNum = [String]()
            for i in 140..<200 {
                heightNum.append(String(i))
            }
            settingValue = heightNum
            
        case .pushTime:
            categoryName = Const.PUSH_TIME
            var timeNum = [String]()
            for i in 0..<24 {
                timeNum.append(String(i))
            }
            settingValue = timeNum
        }
        SettingCategoryLabel.text = categoryName

    }

    @IBAction func settingButton(_ sender: Any) {
        settingNewValue()
    }


    /** PickerでOKボタンを押された際のデリゲート */
    func acceptAction(value: String) {
        textField.text = value
    }
    
    private func settingNewValue() {
        
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
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension SettingForm: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let picker = Picker.make()
        picker.dataList = settingValue
        picker.delegate = self
        picker.open()
    }
    
}



