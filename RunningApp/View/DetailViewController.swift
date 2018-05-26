

import Foundation
import UIKit

protocol DetailViewProtocol: Notify {
    init(_ runData: RealmDataSet, observer: Any, selector: Selector)
}

class DetailViewController: UIViewController, DetailViewProtocol {
    
    var presenter: DetailViewPresenterProtocol!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailView")
        tableView.backgroundColor = AppColor.backgroundColor
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    required init(_ runData: RealmDataSet, observer: Any, selector: Selector) {
        super.init(nibName: nil, bundle: nil)
        presenter = DetailViewPresenter(view: self, runData)
        addObserver(observer, selector: selector)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activateConstraints()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(presentActionSheet))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func activateConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func presentActionSheet() {
        let sheet = UIAlertController(title: "選択してください", message: "削除してもよろしいですか?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
            self.presenter.deleteRunData()
            self.notify()
            self.navigationController?.popViewController(animated: true)
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            
        }))
        present(sheet, animated: true, completion: nil)
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailView", for: indexPath) as! DetailTableViewCell
        (cell.titleTextLabel.text!, cell.valueTextLabel.text!) = presenter.setupCellInfo(indexPath: indexPath.row)
        return cell
    }
    
    
}


