

import Foundation
import RealmSwift

protocol DetailViewModelProtocol {
    func deleteRunData(runData: RealmDataSet)
    func setupCellInfo(indexPath: Int, runData: RealmDataSet) -> (String, String)
}

class DetailViewModel: DetailViewModelProtocol {
 
    func deleteRunData(runData: RealmDataSet) {
        try! RealmDataSet.realm.write() {
            RealmDataSet.realm.delete(runData)
        }
    }
    
    func setupCellInfo(indexPath: Int, runData: RealmDataSet) -> (String, String) {
        switch indexPath {
        case 0:
            return ("距離", runData.distance)
        case 1:
            return ("日付", runData.date)
        case 2:
            return ("消費カロリー" ,runData.calorie)
        case 3:
            return ("時間", runData.time)
        case 4:
            return ("スピード", runData.speed)
        default:
            return ("", "")
        }
    }
    
}
