
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {

        super.viewDidLoad()
        
        delegate = self
 
        /** barTintColor -> tabBarのbackgroundColor
          *  tintColor    -> 選択されてるTabのColor
          *  unselectedItemTintColor -> 選択されていないアイテムのColor
          */
        UITabBar.appearance().barTintColor = AppColor.navigationAndTabBarColor
        UITabBar.appearance().tintColor = AppColor.selectedTabBarColor
        UITabBar.appearance().unselectedItemTintColor = UIColor.black.withAlphaComponent(0.5)

        // MARK: - Home
        let home = HomeViewController()
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home")!, selectedImage: UIImage(named: "home")!)
        let homeNv = UINavigationController(rootViewController: home)
        
////        // MARK: - MyPage
//        let myPage = MyPageViewController()
//        myPage.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(named: "account")!, selectedImage: UIImage(named: "account")!)
//        let myPageNv = UINavigationController(rootViewController: myPage)

        // MARK: - Setting
        let setting = SettingController()
        setting.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "setting")!, selectedImage: UIImage(named: "setting")!)
        let settingNv = UINavigationController(rootViewController: setting)

        setViewControllers([homeNv, settingNv], animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

    }

}


