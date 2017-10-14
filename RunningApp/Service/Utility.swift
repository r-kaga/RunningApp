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
        
        //以下で登録処理
        let content = UNMutableNotificationContent()
        content.title = "SimWay";
        content.body = "SimWayからの通知だよ";
        content.sound = UNNotificationSound.default()
        content.badge = 1
        content.userInfo = ["id" : "activityGoal"]
        let date = DateComponents(hour: setTime)//(month:7, day:7, hour:12, minute:0)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: date, repeats: true)//1回だけならrepeatsをfalseに
        let request = UNNotificationRequest.init(identifier: "simwayNotification", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
//        center.delegate = self
        
    }
    
    
    /* 今日の日付を文字列で取得 */
    static func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let now = Date()
        return formatter.string(from: now)
    }
    
    static func showCompleteDialog() {
        let view = CompleteDialog.make()
        view?.open()
    }
    

    
}
