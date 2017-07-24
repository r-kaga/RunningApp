//
//  NewsController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/07/24.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//
    
import UIKit
import Alamofire
import SwiftyJSON

class News: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var label: UILabel!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // itemsをJSONの配列と定義
    var items: [JSON] = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        // TableViewを作成
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let label = UILabel()
        label.center = self.view.center
        label.text = "fweafwef"
        self.view.addSubview(label)
        
        
        // QiitaのAPIからデータを取得
        let listUrl = "https://qiita.com/api/v1/items"
        Alamofire.request(listUrl).responseJSON { response in
            
            let json = JSON(response.result.value ?? 0)
            json.forEach{(_, data) in
                self.items.append(data)
            }
            print(self.items)
            tableView.reloadData()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(items)
        
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        
        cell.textLabel?.text = items[indexPath.row]["title"].string
        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row]["updated_at"].stringValue)"
        return cell
    
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contentBody = items[indexPath.row]["body"].stringValue
        print(contentBody)
        
        let ContentRC = ContentReaderController()
        ContentRC.contentBody = contentBody
        let view = ContentRC.loadNib()
//        present(ContentRC, animated: true, completion: nil)
        self.view.addSubview(view!)
        
    }
    
    
    /// HTML形式で記述された文字列をNSAttributedStringに変換する
    ///
    /// - Parameter text: 変換する文字列
    /// - Returns: HTMLドキュメントに変換されたNSAttributedString
    func parseText2HTML(sourceText text: String) -> NSAttributedString? {
        
        // 受け取ったデータをUTF-8エンコードする
        let encodeData = text.data(using: String.Encoding.utf8, allowLossyConversion: true)
        
        // 表示データのオプションを設定する
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType as AnyObject,
            NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue as AnyObject
        ]
        
        // 文字列の変換処理
        var attributedString:NSAttributedString?
        do {
            attributedString = try NSAttributedString(
                data: encodeData!,
                options: attributedOptions,
                documentAttributes: nil
            )
        } catch let e {
            // 変換でエラーが出た場合
        }
        
        return attributedString
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 
//        if segue.identifier == "contentBody" {
//            let ContentReaderController = segue.destination as! ContentReaderController
//            ContentReaderController.contentBody = sender as! String
//        }
//        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
        
}
