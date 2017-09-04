// Swift3.0

import UIKit

class ViewController: UIViewController {
    
    var controllerArray : [UIViewController] = []
    var pageMenu : CAPSPageMenu?
    
    // タブ情報
    let tabMenuItem = [
        "Home",
        "MyPage",
        "News"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for site in tabMenuItem {
//            let controller: UIViewController = PageMenuViewController(nibName: site, bundle: nil)
//            controller.title = site
//            controller.siteUrl = site["url"]!
//            controller.webView = UIWebView(frame : self.view.bounds)
//            controller.webView.delegate = controller
//            controller.view.addSubview(controller.webView)
//            let req = URLRequest(url: URL(string:controller.siteUrl!)!)
//            controller.webView.loadRequest(req)
//            controllerArray.append(controller)
//        }
        
        let home: UIViewController = Home()
        home.title = "Home"
        controllerArray.append(home)
        
        let myPage: UIViewController = MyPage()
        myPage.title = "MyPage"
        controllerArray.append(myPage)
        
        let news: UIViewController = News()
        news.title = "News"
        controllerArray.append(news)
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.black),
            .viewBackgroundColor(UIColor.black),
            .bottomMenuHairlineColor(UIColor.blue),
            .selectionIndicatorColor(UIColor.orange),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 18.0)!),
            .centerMenuItems(true),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .menuMargin(36),
            .selectedMenuItemLabelColor(UIColor.white),
            .unselectedMenuItemLabelColor(UIColor.white)
        ]
        
        // Initialize scroll menu
        let rect = CGRect(origin: CGPoint(x: 0,y :20), size: CGSize(width: self.view.frame.width, height: self.view.frame.height))
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: rect, pageMenuOptions: parameters)
        
        self.addChildViewController(pageMenu!)
        self.view.addSubview(pageMenu!.view)
        
        pageMenu!.didMove(toParentViewController: self)
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}





//    
//    
//    
//      /*
//     * アイコンを変更
//     * name指定するのはInfo.plistでCFBundleAlternateIcons設定したkey、file名とは異なる
//     * nilでデフォルトのアイコンに
//     */
//    @IBAction func chaneIcon1(_ sender: Any) {
//        changeIcon(name: "sel")
//    }
//    
//    @IBAction func chaneIcon2(_ sender: Any) {
//        changeIcon(name: nil)
//    }
//    
//    /*
//     * アイコンを変更するfunc
//     */
//    private func changeIcon(name: String?) {
//        UIApplication.shared.setAlternateIconName(name) { error in
//            if let e = error {
//                print(e)
//            }
//        }
//    }
//    

