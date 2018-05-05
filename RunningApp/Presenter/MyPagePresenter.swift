
import Foundation
import RealmSwift

protocol MyPagePresenterProtocol {
    var myInfo: Results<RealmDataSet> { get }
    init(view: MyPageProtocol)
}

class MyPagePresenter: MyPagePresenterProtocol {
    
    var myInfo: Results<RealmDataSet> {
        return model.myInfo
    }
    
    private let view: MyPageProtocol
    private let model: MyPageModelProtocol
    
    required init(view: MyPageProtocol) {
        self.view = view
        self.model = MyPageModel()
        model.addObserver(self, selector: #selector(self.updateView))
    }
    
    deinit {
        model.removeObserver(self)
    }
    
    @objc func updateView() {
        print("updateView")
    }
    
}
