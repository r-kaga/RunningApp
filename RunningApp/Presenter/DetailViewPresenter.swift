

import Foundation

protocol DetailViewPresenterProtocol {
    var view: DetailViewProtocol { get }
    var model: DetailViewModelProtocol { get }
    var runData: RealmDataSet { get }
    var numberOfRowsInSection: Int { get }
    init(view: DetailViewProtocol, _ data: RealmDataSet)
    func deleteRunData()
    func setupCellInfo(indexPath: Int) -> (String, String)
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
    
    func deleteRunData() {
        model.deleteRunData(runData: runData)
    }
    
    func setupCellInfo(indexPath: Int) -> (String, String) {
        return model.setupCellInfo(indexPath: indexPath, runData: runData)
    }

}
