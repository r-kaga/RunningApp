

import UIKit

protocol PickerDelegate: class {
    func acceptAction(value: String)
}

class Picker: UIView,  UIPickerViewDelegate, UIPickerViewDataSource, DialogProtocol {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var buttonViewOutlet: UIStackView!
    @IBOutlet weak var picker: UIPickerView!
    
    weak var delegate: PickerDelegate?

    var dataList = [String]()
    var selectedValue: String?

    /** ビュー作成
     * @return Parts
     */
    class func make() -> Picker {
        let view = UINib(nibName: "Picker", bundle: nil).instantiate(withOwner: self, options: nil)[0]
        as! Picker
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self

        buttonViewOutlet.addBorder(types: [.Bottom], color: UIColor(red: 215/255, green: 215/255, blue: 219/255, alpha: 0.8))
        acceptButton.addBorder(types: [.Left], color: UIColor(red: 215/255, green: 215/255, blue: 219/255, alpha: 0.8))
        
        // はじめに表示する項目を指定
        picker.selectRow(0, inComponent: 0, animated: true)
    }

    
    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // 表示する列数
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // アイテム表示個数を返す
        return dataList.count
    }
    
    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 表示する文字列を返す
        return dataList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 選択時の処理
        print(dataList[row])
        selectedValue = dataList[row]
    }

    @IBAction func acceptAction(_ sender: Any) {
        guard let value = selectedValue else { return }
        self.delegate?.acceptAction(value: value)
        self.close()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.close()
    }
    /** 表示 */
    func open() {
        let app = UIApplication.shared.delegate as! AppDelegate
        self.frame = (app.window?.frame)!
        self.alpha = 0.0
        app.window?.addSubview(self)
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
            self.selectedValue = self.dataList[0]
        }
    }
    
    /** タッチイベント
     * @param touches -
     * @param event -
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.close()
    }
    
}
