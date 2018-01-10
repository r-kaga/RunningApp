
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
    
    /** completeダイアログの表示
     */
    static func showCompleteDialog() {
        let view = CompleteDialog.make()
        view?.open()
    }
    
    /** loadingダイアログの表示
     */
    static func showLoading() {
        let view = Loading.make()
        view?.startLoading()
    }
    

    
}
