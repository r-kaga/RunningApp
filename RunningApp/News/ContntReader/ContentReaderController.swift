//
//  ContentReaderController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/07/24.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit

class ContentReaderController: UIViewController {

    @IBOutlet weak var textReaderView: UITextView!
    var contentBody: String?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadNib() -> UIView? {
        
        let view = Bundle.main.loadNibNamed("ContentReaderController", owner: self, options: nil)?.first as! UIView
        view.frame = self.view.frame
        return view
    }
    
    
    /** Viewインスタンス作成
     * @return View
     */
    func add() -> UIView? {
        let view = UINib(nibName: "ContentReaderController", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = self.view.frame
        self.setText()
        return view
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        self.setText()
    }
    
    func setText() {
        if let text = contentBody {
            self.textReaderView.text = text
            self.view.addSubview(textReaderView)
        }
    }

    /// HTML形式で記述された文字列をNSAttributedStringに変換する
    /// - Parameter text: 変換する文字列
    /// - Returns: HTMLドキュメントに変換されたNSAttributedString
    func parseText2HTML(sourceText text: String) -> NSAttributedString? {
        
        // 受け取ったデータをUTF-8エンコードする
        let encodeData = text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        // 表示データのオプションを設定する
        let attributedOptions : [String: AnyObject] = [
            NSAttributedString.DocumentAttributeKey.documentType.rawValue: NSAttributedString.DocumentType.html as AnyObject,
            NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue: String.Encoding.utf8.rawValue as AnyObject
        ]
        
//        // 文字列の変換処理
        var attributedString:NSAttributedString?
//        do {
//            attributedString = try NSAttributedString(
//                data: encodeData!,
//                options: attributedOptions,
//                documentAttributes: nil
//            )
//        } catch let e {
//            // 変換でエラーが出た場合
//        }
        
        return attributedString
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    


}
