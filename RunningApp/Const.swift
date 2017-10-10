//
//  Const.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/06.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation

struct Const {
    
    /* 設定項目
     */
    enum SettingType: Int {
        case weight     = 0
        case height     = 1
        case pushTime   = 2
    }
    
    enum ErrorType: Error {
        case notInteger
        case empty
    }
    
    
    enum WorkType {
        case run
        case wallk
    }
    
    
    static let PUSH_TIME = "pushTime"
    
}
