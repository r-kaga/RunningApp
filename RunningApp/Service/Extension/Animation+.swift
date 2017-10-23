//
//  Animation+.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/22.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
   func touchStartAnimation(){
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {() -> Void in
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95);
                        self.alpha = 0.7
        },
                       completion: nil
        )
    }
    
    func touchEndAnimation(){
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {() -> Void in
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                        self.alpha = 1
        },
                       completion: nil
        )
    }

  
    
    
}
