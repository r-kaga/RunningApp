

import Foundation

protocol RunManagePresenterProtocol {
    init(view: RunManageViewProtocol)
}

class RunManagePresenter: RunManagePresenterProtocol {
    
    private var view: RunManageViewProtocol!
    private var model: RunManageModelProtocol!
    
    required init(view: RunManageViewProtocol) {
        self.view = view
        self.model = RunManageModel()
    }
    
}
