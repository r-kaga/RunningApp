
import Foundation
import UIKit

protocol RunManageViewProtocol {
    
}

class RunManageViewController: UIViewController, RunManageViewProtocol {
    
    private(set) var presenter: RunManagePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        presenter = RunManagePresenter(view: self)
    }
    
}
