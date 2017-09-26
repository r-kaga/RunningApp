//
//  WorkOutController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/09/25.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


enum WorkType {
    case run
    case wallk
}

class WorkController: UIViewController {
    
    var timer: Timer!
    var countImageView: UIImageView!
    var count = 0
    
//    let type: WorkType!
    
//    init(type: WorkType) {
//        self.type = type
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Ranrastic"
//        
//        let workResultSpace = UIView(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: AppSize.height / 2))
//        workResultSpace.backgroundColor = .white
//        
//        let mainResultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: AppSize.width, height: workResultSpace.frame.height / 2))
//        mainResultLabel.text = "00:00:00"
//        mainResultLabel.backgroundColor = .white
//        mainResultLabel.textColor = .black
//        mainResultLabel.textAlignment = .center
//        mainResultLabel.font = UIFont.systemFont(ofSize: 25)
//        workResultSpace.addSubview(mainResultLabel)
//        
//        self.view.addSubview(workResultSpace)
        
        countImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: AppSize.width / 2, height: AppSize.height / 2))
        countImageView.center = self.view.center
        countImageView.image = UIImage(named: "0.jpg")!
        self.view.addSubview(countImageView)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.countImageAnimation()
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.countImageAnimation), userInfo: nil, repeats: true)
    }

    /** countImageViewのアニメーション
      */
    func countImageAnimation() {
        
        count = count + 1
        
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { _ in
            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)

        UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseOut, animations: { _ in
            self.countImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.countImageView.alpha = 0
        }, completion: { _ in
            self.countImageView.image = UIImage(named: "\(self.count).jpg")!
            self.countImageView.alpha = 1
            
            if self.count == 3 {
                self.countImageView.removeFromSuperview()
            }
        })

        
//        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: { _ in
//            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.2, delay: 0.8, options: .curveEaseOut, animations: { _ in
//            self.countImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.countImageView.alpha = 0
//        }, completion: { _ in
//            self.countImageView.image = UIImage(named: "\(2).jpg")!
//            self.countImageView.alpha = 1
//        })
//

//        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: { _ in
//            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.2, delay: 0.8, options: .curveEaseOut, animations: { _ in
//            self.countImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.countImageView.alpha = 0
//        }, completion: { _ in
//            self.countImageView.image = UIImage(named: "\(1).jpg")!
//            self.countImageView.alpha = 1
//        })
//
//
//        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: { _ in
//            self.countImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//        }, completion: nil)
//
//        UIView.animate(withDuration: 0.2, delay: 0.8, options: .curveEaseOut, animations: { _ in
//            self.countImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.countImageView.alpha = 0
//        }, completion: { _ in
//            self.countImageView.image = UIImage(named: "\(0).jpg")!
//            self.countImageView.alpha = 1
//            self.countImageView.removeFromSuperview()
//        })
        
        
        
    }
    
    /** Endボタン押し時
      *
      */
    @IBAction func endAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
