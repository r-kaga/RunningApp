
import UIKit

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {

        super.viewDidLoad()
        
        self.delegate = self
        
        let tabBar = UITabBar()
        tabBar.barTintColor = .gray
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .white
        
        let home = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home")!, tag: 1)
        let homeNv = UINavigationController(rootViewController: home)
        
        let myPage = MyPage()
        myPage.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(named: "account")!, tag: 2)
        let myPageNv = UINavigationController(rootViewController: myPage)
        
        let setting = SettingController()
        setting.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "setting")!, tag: 3)
        let settingNv = UINavigationController(rootViewController: setting)

        setViewControllers([homeNv, myPageNv, settingNv], animated: false)
    }


}



class MyTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 58
        return size
    }
    
}
