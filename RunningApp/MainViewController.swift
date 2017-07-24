// Swift3.0

import UIKit

class ViewController: UIViewController {
    
    // インスタンス配列
    var controllerArray : [UIViewController] = []
    var pageMenu : CAPSPageMenu?
    
    // サイト情報
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
        
        
        let home: UIViewController = Home(nibName: "Home", bundle: nil)
        home.title = "Home"
        controllerArray.append(home)
        
        let myPage: UIViewController = MyPage(nibName: "MyPage", bundle: nil)
        myPage.title = "MyPage"
        controllerArray.append(myPage)
        
        let news: UIViewController = News(nibName: "News", bundle: nil)
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







////
////  ViewController.swift
////  sampleUIViewApp
////
////  Created by 加賀谷諒 on 2017/06/27.
////  Copyright © 2017年 ryo kagaya. All rights reserved.
////
//
//import UIKit
//import MaterialComponents.MaterialTabs
//import MaterialComponents.MaterialNavigationBar
//
//
//class MainViewController:
//    UIViewController
//    
//{
//
//    @IBOutlet weak var attributedLabel: UILabel!
//    @IBOutlet weak var pickerView: UIPickerView!
//
//    @IBOutlet weak var rotateImageView: UIImageView!

//
//    override func viewDidLoad() {
//        super.viewDidLoad()

//
////        /*
////         * 属性付き文字列は、異なる種類の属性をテキストに割り当てます。
////         * 一度に複数の属性をテキストの一部に割り当てることができます。このチュートリアルでは、ラベル内のテキストの各単語に一連の属性を割り当てます
////         */
////        
////        //  a regular string is created and this is loaded into a mutable attributed string.
////        let string = "Testing Attributed Strings"
////        let attributedString = NSMutableAttributedString(string: string)
////        
////        let firstAttributes:[String:Any] = [NSForegroundColorAttributeName: UIColor.blue, NSBackgroundColorAttributeName: UIColor.yellow, NSUnderlineStyleAttributeName: 1]
////        let secondAttributes:[String:Any] = [NSForegroundColorAttributeName: UIColor.red, NSBackgroundColorAttributeName: UIColor.blue, NSStrikethroughStyleAttributeName: 1]
////        let thirdAttributes:[String:Any] = [NSForegroundColorAttributeName: UIColor.green, NSBackgroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 40)]
////        
////        // The attributes are added to the substrings of the attributes strings
////        attributedString.addAttributes(firstAttributes, range: NSRange(location: 0, length: 8))
////        attributedString.addAttributes(secondAttributes, range: NSRange(location: 8, length: 11))
////        attributedString.addAttributes(thirdAttributes, range: NSRange(location: 19, length: 7))
////        
////        let attributedLabel = UILabel(frame: CGRect(x: self.view.frame.width / 3, y: self.view.frame.height / 10, width: 100, height: 20))
////        attributedLabel.attributedText = attributedString
////        attributedLabel.sizeToFit()
////        attributedLabel.center = self.view.center
////        self.view.addSubview(attributedLabel)
//
//        
//        let floatingButton = MDCFloatingButton()
//        floatingButton.setTitle("+", for: .normal)
//        floatingButton.sizeToFit()
//        floatingButton.center = self.view.center
//        floatingButton.addTarget(self, action: #selector(self.floatingButtonDidTap), for: .touchUpInside)
//        self.view.addSubview(floatingButton)
//        
//    }
//    
//    
//    func floatingButtonDidTap() {
//        UIView.animate(withDuration: 2.0, animations: {
//            self.rotateImageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
//        })
//    }
//    
//    func senderHome() {
//        let nex : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController")
//        self.present(nex as! UIViewController, animated: true, completion: nil)
//    }
//   
//    @IBAction func senderUIAnimation(_ sender: Any) {
//        let nex : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "UIAnimation")
//        self.present(nex as! UIViewController, animated: true, completion: nil)
//    }
//        
//    @IBAction func senderCollectionView(_ sender: Any) {
//        let storyboard: UIStoryboard = UIStoryboard(name: "MaterialViewController", bundle: nil)
//        let nextView = storyboard.instantiateInitialViewController()
//        present(nextView!, animated: true, completion: nil)
//
//    }
//
//    @IBAction func gotoGesture(_ sender: Any) {
//        let nex : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "UIPanGestureRecognizer")
//        self.present(nex as! UIViewController, animated: true, completion: nil)
//    }
//    
//    @IBAction func rotateImage(_ sender: Any) {
//        UIView.animate(withDuration: 2.0, animations: {
//            self.rotateImageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi) / 180.0)
//        })
//    }
//    
//    @IBAction func blurImage(_ sender: Any) {
//        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame = rotateImageView.bounds
//        rotateImageView.addSubview(blurView)
//    }
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

