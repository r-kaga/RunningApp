
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
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let nv = UINavigationController(rootViewController: vc)
        
        let vc3 = SettingController()
        vc3.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "file.png")!, selectedImage: UIImage(named: "0.jpg")!)
        let nv3 = UINavigationController(rootViewController: vc3)
        
        let vc2 = News()
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 2)
        let nv2 = UINavigationController(rootViewController: vc2)
        setViewControllers([nv, nv2, nv3], animated: false)
    }
    

}



class MyTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 58
        return size
    }
    
}
