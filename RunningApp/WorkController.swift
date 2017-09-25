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
        
    }
    
    @IBAction func endAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
