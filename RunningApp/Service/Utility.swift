//
//  Utility.swift
//  RunningApp
//
//  Created by 加賀谷諒 on 2017/10/09.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import Foundation
import UserNotifications


struct Utility {

    
    /**
     * ローカル通知の時間をセットする
     * @param setTime :Int - 通知したい時間
     */
    static func setLocalPushTime(setTime: Int) {
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

        //以下で登録処理
        let content = UNMutableNotificationContent()
        content.title = "今日は運動しましたか"
        content.body = "毎日の運動を大切にしましょう"
        content.sound = UNNotificationSound.default()
        content.badge = 1
        content.userInfo = ["id" : "activityGoal"]
        let date = DateComponents(hour: setTime)//(month:7, day:7, hour:12, minute:0)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)//1回だけならrepeatsをfalseに
        let request = UNNotificationRequest.init(identifier: "runKitNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
//        center.delegate = self
        
    }
    
    
    /** 今日の日付を文字列で取得
     * - return 2017-10-20 15:14:30
     */
    static func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let now = Date()
        return formatter.string(from: now)
    }
    
    /**
     * completeダイアログの表示
     */
    static func showCompleteDialog() {
        let view = CompleteDialog.make()
        view?.open()
    }
    
    /**
     * loadingダイアログの表示
     */
    static func showLoading() {
        let view = Loading.make()
        view?.startLoading()
    }
    
    /** collectionViewのpathから、運動のタイプをタプルで返却
     *  ("Category Image", "CollectionView Image")
     */
    static func pathConvertWorkType(path: Int) -> (String, String) {
        switch path {
        case Const.WorkType.running.rawValue:
            return ("directionsRun", "running")
        case Const.WorkType.wallking.rawValue:
            return ("directionsWalk", "walking")
        default:
            return ("directionsRun", "running")
        }
    }
    
    /**
     *
     */
    static func getDescrition(distance: Double) -> String {
        var str = ""
        switch distance {
        case 0...5: // 0Km~10Km
            str = "まずは5km突破を目指そう"
        case 5...10: // 0Km~10Km
            str = "あともう少しでハーフマラソン完走"
        
        case 10...15: // 10Km~30Km
            str = "フルマラソン完走まで頑張ろう!"
        
        case 15...20: // 10Km~30Km
            str = "フルマラソン完走まで頑張ろう!"
            
        case 20...25: // 10Km~30Km
            str = "フルマラソン完走まで頑張ろう!"
            
        case 25...30: // 10Km~30Km
            str = "フルマラソン完走まで頑張ろう!"
            
        case 30...35: // 10Km~30Km
            str = "フルマラソン完走まで頑張ろう!"
  
        case 35...40: // 10Km~30Km
            str = "フルマラソン完走まで頑張ろう!"
        
        case 40...47: // 10Km~30Km
            str = "フルマラソン完走まで頑張ろう!"
            
        case 47...50: // 47Km~10Km
            str = "フルマラソン完走!"
        
        case 50...100: // 0Km~10Km
            str = "万里の長城を登りきろう"
            
        default:
            str = "風になろう"
        }

        str.insert("〜", at: str.startIndex)
        str.append("〜")

        return str
    }
    
}
