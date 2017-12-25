

import Foundation

struct Const {
    
    /* 設定項目
     */
    enum SettingType: Int {
        case weight     = 0
        case height     = 1
        case pushTime   = 2
    }
    
    /** 運動の種類のタイプ */
    enum WorkType: Int {
        case wallking = 0
        case running  = 1
    }
    
    enum ErrorType: Error {
        case notInteger
        case empty
    }
    

    static let PUSH_TIME = "pushTime"
    
}
