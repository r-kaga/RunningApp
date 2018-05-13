

import Foundation
import UIKit

protocol DetailViewProtocol {
    init(_ runData: RealmDataSet)
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
    
    required init(_ runData: RealmDataSet) {
        super.init(nibName: nil, bundle: nil)
        presenter = DetailViewPresenter(view: self, runData)
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
    }
    
    private func activateConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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
        (cell.titleTextLabel.text, cell.valueTextLabel.text) = {
            switch indexPath.row {
            case 0:
                return ("距離", presenter.runData.distance)
            case 1:
                return ("日付", presenter.runData.date)
            case 2:
                return ("消費カロリー" ,presenter.runData.calorie)
            case 3:
                return ("時間", presenter.runData.time)
            case 4:
                return ("スピード", presenter.runData.speed)
            default:
                return ("", "")
            }
        }()
        return cell
    }
    
    
}


