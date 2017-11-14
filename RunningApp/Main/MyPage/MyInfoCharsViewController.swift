
import UIKit

class MyInfoCharsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCharts()
    }
    
    private func setupCharts() {
        
        let charts = MyPageChartsViewController()
        let containerView = UIView(frame: CGRect(x: 10, y: AppSize.statusBarAndNavigationBarHeight, width: AppSize.width, height: AppSize.height - (AppSize.height / 4)))
        containerView.addSubview(charts.view)
        self.view.addSubview(containerView)
        
    }
    
    
}
