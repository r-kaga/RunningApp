

import Foundation
import UIKit

protocol RunDataListViewProtocol {
    
}

class RunDataListViewController: UIViewController, RunDataListViewProtocol {
    
    private(set) var presenter: RunDataPresenterProtocol!
    
    private lazy var containerView: UIView = {
        let uiview = UIView(frame: CGRect(x: 10, y: AppSize.statusBarAndNavigationBarHeight + 10, width: AppSize.width - 20, height: AppSize.contentViewHeight - 10))
        uiview.backgroundColor = .clear
        return uiview
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: AppSize.width / 2 - 15, height: AppSize.width / 2)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "RunDataInfoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "runDataList")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RunDataPresenter(view: self)
        setupView()
        activateConstraints()
    }
    
    private func setupView() {
        navigationItem.title = "Run Data"
        view.backgroundColor = AppColor.backgroundColor

        containerView.addSubview(collectionView)
        view.addSubview(containerView)
    }

    private func activateConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
    }
    
}

extension RunDataListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.runData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "runDataList", for: indexPath) as! RunDataInfoCollectionViewCell
        cell.setRunData(presenter.runData[indexPath.row])
        return cell
    }

}

