//
//  SecondViewController.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/09/25.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit


class SecondViewController: UIViewController {
    let titleName: String
    
    init(titleName: String) {
        self.titleName = titleName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private lazy var container: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.yellow
        return container
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = titleName
        self.view.addSubview(container)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


