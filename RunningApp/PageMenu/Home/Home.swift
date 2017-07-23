//
//  HomeViewController.swift
//  sampleUIViewApp
//
//  Created by 加賀谷諒 on 2017/07/16.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//


import UIKit
import MaterialComponents

class Home:
    UIViewController ,
    UICollectionViewDataSource,
    UICollectionViewDelegate
    
{
    
    @IBOutlet weak var textLabel: UILabel!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var myCollectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height = UIScreen.main.bounds.size.height
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.width / 2) - 2, height: height / 3)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        // セクション毎のヘッダーサイズ.
        layout.headerReferenceSize = CGSize(width: 5, height: height / 4)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self

        self.view.addSubview(myCollectionView)
        
        textLabel.text = "前回のアクティビティ"
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        self.view.addSubview(textLabel)
        
        
        
    }
    
    /*
     Cellが選択時
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        onSender(indexPath.row)
    }
    
    /*
     Cellの総数
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    /*
     Cellに値を設定
     */
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : UICollectionViewCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "MyCell",
            for: indexPath) 


        let path = indexPath[1]
        let info = [
            "Walking",
            "Running",
            "Training",
            "Work Out"
        ]
    
        let imageView = UIImageView(image: UIImage(named: String(path) + ".jpg" )!)

        imageView.frame = cell.frame
        imageView.center = cell.center
        self.view.addSubview(imageView)
 
        let raisedButton = MDCRaisedButton()
        raisedButton.setElevation(4, for: .normal)
        raisedButton.setTitle(info[path], for: .normal)
        raisedButton.sizeToFit()
        raisedButton.center = cell.center
        self.view.addSubview(raisedButton)

        return cell
    
    }
    
    
    func onSender(_ path: Int) {
        if path == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MaterialViewController") as! MaterialViewController
            present(viewController, animated: true, completion: nil)
        } else {

            
        }

    }
    
    
}

