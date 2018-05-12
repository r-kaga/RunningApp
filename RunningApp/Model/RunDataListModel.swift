

import Foundation
import RealmSwift

protocol RunDataListModelProtocol {
    var runData: Results<RealmDataSet> { get }

}

class RunDataListModel: RunDataListModelProtocol {
    
    var runData: Results<RealmDataSet> {
        return RealmDataSet.getAllData()
    }
    
}
