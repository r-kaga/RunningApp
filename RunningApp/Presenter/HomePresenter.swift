
import Foundation

protocol HomePresenterProtocol {
    func didSelectRunningStart()
    init(view: HomeViewProtocol)
}

class HomePresenter: HomePresenterProtocol {
    
    private let view: HomeViewProtocol
    private let model: HomeModelProtocol
    
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
