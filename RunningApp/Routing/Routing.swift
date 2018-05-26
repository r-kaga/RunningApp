
import Foundation
import UIKit

/**
 * 遷移を管理したいViewControllerでRoutingProtocolを準拠する
 * eg) presenter.transition(self, route: .moreRunData, routingType: .push)
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
    func transition(_ view: UIViewController, route: Routing, routingType: RoutingType, observer: Any?, selector: Selector?)
}

extension RoutingProtocol {

    func transition(_ view: UIViewController, route: Routing, routingType: RoutingType, observer: Any? = nil, selector: Selector? = nil) {
        let vc: UIViewController
        switch route {
        case .startRun:
            vc = RunManageViewController(observer: observer!, selector: selector!)
        case .moreRunData:
            vc = RunDataListViewController(observer: observer!, selector: selector!)
        }
        
        switch routingType {
        case .present:
            view.present(vc, animated: true, completion: nil)
        case .push:
            view.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func dismissView(_ view: UIViewController) {
        view.dismiss(animated: true, completion: nil)
    }
    
}

