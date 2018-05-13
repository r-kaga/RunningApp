

import Foundation

protocol DetailViewPresenterProtocol {
    var view: DetailViewProtocol { get }
    var model: DetailViewModelProtocol { get }
    var runData: RealmDataSet { get }
    var numberOfRowsInSection: Int { get }
    init(view: DetailViewProtocol, _ data: RealmDataSet)
}

class DetailViewPresenter: DetailViewPresenterProtocol {
    
    var view: DetailViewProtocol
    var model: DetailViewModelProtocol
    var runData: RealmDataSet
    
    var numberOfRowsInSection: Int {
        return 5
    }
    
    required init(view: DetailViewProtocol, _ data: RealmDataSet) {
        self.view = view
        self.model = DetailViewModel()
        self.runData = data
    }
    
}
