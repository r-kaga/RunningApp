

import Foundation

protocol SettingPresenterProtocol {
    init(view: SettingViewProtocol)
}

class SettingPresenter: SettingPresenterProtocol {
    
    private var view: SettingViewProtocol
    private var model: SettingModelProtocol
    
    required init(view: SettingViewProtocol) {
        self.view = view
        self.model = SettingModel()
    }

    
}
