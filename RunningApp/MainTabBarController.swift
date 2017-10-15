
import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let tabBar = UITabBar()
        tabBar.barTintColor = .gray
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        
        let vc = Home()
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Home")!, tag: 1)
        let nv = UINavigationController(rootViewController: vc)
        
//        let vc2 = News()
//        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
//        let nv2 = UINavigationController(rootViewController: vc2)
        
        let vc3 = SettingController()
        vc3.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "Settings")!, tag: 2)
        let nv3 = UINavigationController(rootViewController: vc3)

        setViewControllers([nv,nv3], animated: true)
    }
    

}



class MyTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 58
        return size
    }
    
}
