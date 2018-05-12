

import Foundation
import RealmSwift

protocol RunManageModelProtocol {
    func getElapsedTime(startTimeDate: Date) -> String
    func getCurrentCalorieBurned(startTimeDate: Date) -> Double
    func checkCurrentSpeedIsPaceable(currentSpeed: Double, pace: Double) -> currentSpeedType
    func registResults(view: RunManageCardView)
}


class RunManageModel: RunManageModelProtocol {
    
    /** 開始時間から現在の経過時間を返却
     * - return 現在の経過時間 / HH:mm:ss
     */
    func getElapsedTime(startTimeDate: Date) -> String {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTimeDate)
        let hour = (Int)(fmod((currentTime / 60 / 60), 60))
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        return  "\(String(format:"%02d", hour)):\(String(format:"%02d", minute)):\(String(format:"%02", second))"
    }

    /** カロリー計算 */
    func getCurrentCalorieBurned(startTimeDate: Date) -> Double {
        
        var calorie: Double = 0.0
        if let weight = UserDefaults.standard.string(forKey: "weight") {
            // タイマー開始からのインターバル時間
            let currentTime = Date().timeIntervalSince(startTimeDate)
            let hour = (Double)(fmod((currentTime / 60 / 60), 60))
            let minute = (Double)(fmod((currentTime/60), 60))
            let second = (Double)(fmod(currentTime, 60))
            
            let time = hour + (minute / 60) + (second / 60 / 60)
            
            let calcu = (1.05 * 8.0 * time * Double(weight)!)
            calorie = round(calcu * 10.0) / 10.0
        }
        return calorie
    }
    
    /** 現在のスピードと設定した理想のペースを比較する */
    func checkCurrentSpeedIsPaceable(currentSpeed: Double, pace: Double) -> currentSpeedType {
        var type: currentSpeedType?
        
        switch currentSpeed {
        case let e where e < pace:
            type = .up
        case let e where e > pace + 1.0:
            type = .down
        case pace + 0.0...pace + 0.9:
            type = .maintain
        default:
            type = .notMatched
        }
        return type!
    }
    
    /** DBに登録 */
    func registResults(view: RunManageCardView) {
        guard let totalDistance  = view.distanceLabel.text,
            let speed      = view.speedLabel.text,
            let time       = view.elapsedTimeLabel.text,
            let calorie    = view.calorieLabel.text
            else { return }
        
        let realm = RealmDataSet.realm
        let dataSet = RealmDataSet()
        
        dataSet.id          = dataSet.getNewId
        dataSet.date        = Utility.getNowClockString()
        dataSet.calorie     = calorie
        dataSet.distance    = totalDistance
        dataSet.speed       = speed
        dataSet.time        = time
        
        try! realm.write {
            realm.add(dataSet)
        }
    }
    
}
