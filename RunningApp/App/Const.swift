

import Foundation

struct Const {

    /** 運動の種類のタイプ */
    enum WorkType: Int {
        case wallking = 0
        case running  = 1
    }
    
    enum ErrorType: Error {
        case notInteger
        case empty
    }
    
    static let defaulPaceSpeed = 5.0
    
    static let PUSH_TIME = "pushTime"
    
}
