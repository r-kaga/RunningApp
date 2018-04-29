

import UIKit

protocol HomeViewProtocol {
    func startRunning()
}

class HomeViewController: UIViewController {
    
    private(set) var presenter: HomePresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter = HomePresenter(view: self)
    }
    
    private func setupView() {
        navigationItem.title = "Home"
        view.backgroundColor = AppColor.backgroundColor
    }

}


extension HomeViewController: HomeViewProtocol {
    
    func startRunning() {
        
    }
    
}
