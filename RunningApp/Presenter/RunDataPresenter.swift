
import Foundation
import RealmSwift

protocol RunDataPresenterProtocol {
    var runData: Results<RealmDataSet> { get }
    init(view: RunDataListViewProtocol)
}

class RunDataPresenter: RunDataPresenterProtocol {

    private var view: RunDataListViewProtocol!
    private var model: RunDataListModel!

    var runData: Results<RealmDataSet> {
        return model.runData
    }
    
    required init(view: RunDataListViewProtocol) {
        self.view = view
        self.model = RunDataListModel()
    }
    
    
}
