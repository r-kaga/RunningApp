
import Foundation
import RealmSwift

protocol HomePresenterProtocol {
    var latestData: Results<RealmDataSet> { get }
    func didSelectRunningStart()
    init(view: HomeViewProtocol)
}

class HomePresenter: HomePresenterProtocol {
    
    private let view: HomeViewProtocol
    private let model: HomeModelProtocol
    
    var latestData: Results<RealmDataSet> {
        return model.latestData
    }
    
    required init(view: HomeViewProtocol) {
        self.view = view
        self.model = HomeModel()
        model.addObserver(self, selector: #selector(self.updateView))
    }
    
    deinit {
        model.removeObserver(self)
    }
    
    @objc func updateView() {
        print("updateView")
    }
    
    func didSelectRunningStart() {
        print("didSelectRunningStart")
    }
    
}
