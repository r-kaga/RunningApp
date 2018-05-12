
import Foundation

protocol RunDataPresenterProtocol {
    init(view: RunDataListViewProtocol)
}

class RunDataPresenter: RunDataPresenterProtocol {

    private var view: RunDataListViewProtocol!
    private var model: RunDataListModel!
    
    required init(view: RunDataListViewProtocol) {
        self.view = view
        self.model = RunDataListModel()
    }
    
    
}
