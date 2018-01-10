
import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {

        super.viewDidLoad()
        
        delegate = self
 
        /** barTintColor -> tabBarのbackgroundColor
          *  tintColor    -> 選択されてるTabのColor
          */
        UITabBar.appearance().barTintColor = AppSize.navigationAndTabBarColor
        UITabBar.appearance().tintColor = .white

        // MARK: - Home
        let home = UIStoryboard(name: "Home", bundle: nil).instantiateInitialViewController() as! HomeViewController
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home")!, selectedImage: UIImage(named: "home")!)
        let homeNv = UINavigationController(rootViewController: home)
        
        // MARK: - MyPage
        let myPage = MyInfoViewController()
        myPage.tabBarItem = UITabBarItem(title: "MyPage", image: UIImage(named: "account")!, selectedImage: UIImage(named: "account")!)
        let myPageNv = UINavigationController(rootViewController: myPage)
    
        // MARK: - Setting
        let setting = SettingController()
        setting.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(named: "setting")!, selectedImage: UIImage(named: "setting")!)
        let settingNv = UINavigationController(rootViewController: setting)

        setViewControllers([homeNv, myPageNv, settingNv], animated: false)
    }


}


