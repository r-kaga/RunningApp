
import Foundation
import RealmSwift

protocol RunDataPresenterProtocol {
    var runData: Results<RealmDataSet> { get }
    func transition(_ view: RunDataListViewController, indexPath: Int, observer: Any, selector: Selector)
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
    
    func transition(_ view: RunDataListViewController, indexPath: Int, observer: Any, selector: Selector) {
        let vc = DetailViewController(runData[indexPath], observer: observer, selector: selector)
        view.navigationController?.pushViewController(vc, animated: true)
    }

}
