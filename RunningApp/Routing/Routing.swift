
import Foundation
import UIKit

/**
 * 遷移を管理したいViewControllerでRoutingProtocolを準拠する
 * eg) presenter.getRouting(self, route: .moreRunData, routingType: .push)
 */

enum Routing: String {
    case startRun
    case moreRunData
}

enum RoutingType {
    case push
    case present
}

protocol RoutingProtocol {
    func getRouting(_ view: UIViewController, route: Routing, routingType: RoutingType)
}

extension RoutingProtocol {
    
    func getRouting(_ view: UIViewController, route: Routing, routingType: RoutingType) {
        let vc: UIViewController
        switch route {
        case .startRun:
            vc = RunManageViewController()
        case .moreRunData:
            vc = RunDataListViewController()
        }
        
        switch routingType {
        case .present:
            view.present(vc, animated: true, completion: nil)
        case .push:
            view.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

