//
//  ViewController.swift
//  sampleAnimationApp
//
//  Created by 加賀谷諒 on 2017/07/13.
//  Copyright © 2017年 ryo kagaya. All rights reserved.
//

import UIKit
import SnapKit
import MaterialComponents
import MaterialComponents.MaterialDialogs


class ViewController:
    UIViewController,
    UIViewControllerTransitioningDelegate

{

    let interactor = Interactor()

//    private lazy var container: UIView = {
//        let container = UIView()
//        container.backgroundColor = UIColor.gray
//        
//        let button = UIButton(type: .system)
//        container.addSubview(button)
//        button.setTitle("tap Me", for: .normal)
//        button.tintColor = UIColor.white
//        button.backgroundColor = UIColor.blue
//        button.addTarget(self, action: #selector(onTappedPush(_:)), for: .touchUpInside)
//        button.snp.makeConstraints { make in
//            make.width.equalTo(200)
//            make.height.equalTo(40)
//            make.center.equalTo(container)
//        }
//        return container
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.addSubview(container)
//        container.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        navigationItem.title = "Home"

        self.view.backgroundColor = UIColor.white

        
        let raisedButton = MDCRaisedButton()
        raisedButton.setElevation(4, for: .normal)
        raisedButton.setTitle("Description Alert", for: .normal)
        raisedButton.sizeToFit()
        raisedButton.center = CGPoint(x: self.view.center.x, y: self.view.frame.height / 6)
        raisedButton.addTarget(self, action: #selector(self.onMDCAlertShow), for: .touchUpInside)
        self.view.addSubview(raisedButton)
        
        
        let flatButton = MDCFlatButton()
        flatButton.customTitleColor = UIColor.gray
        flatButton.setTitle("GoToParticle", for: .normal)
        flatButton.sizeToFit()
        flatButton.center =  CGPoint(
                x: self.view.frame.width / 4,
                y: self.view.frame.height / 4
            )
        flatButton.addTarget(self, action: #selector(self.onSender), for: .touchUpInside)
        flatButton.tag = 1
        self.view.addSubview(flatButton)

        
        let CollectionViewRaisedButton = MDCRaisedButton()
        CollectionViewRaisedButton.setElevation(4, for: .normal)
        CollectionViewRaisedButton.setTitle("stackBox", for: .normal)
        CollectionViewRaisedButton.sizeToFit()
        CollectionViewRaisedButton.center = CGPoint(
                x: self.view.frame.width - (self.view.frame.width / 4),
                y: self.view.frame.height / 4
            )
        CollectionViewRaisedButton.addTarget(self, action: #selector(self.onSender), for: .touchUpInside)
        CollectionViewRaisedButton.tag = 2
        self.view.addSubview(CollectionViewRaisedButton)
        
        
        let snapBehaviourButton = MDCRaisedButton()
        snapBehaviourButton.customTitleColor = UIColor.white
        snapBehaviourButton.setTitle("SnapBehaviour", for: .normal)
        snapBehaviourButton.sizeToFit()
        snapBehaviourButton.center =  CGPoint(
            x: self.view.frame.width / 4,
            y: self.view.frame.height / 3
        )
        snapBehaviourButton.addTarget(self, action: #selector(self.onSender), for: .touchUpInside)
        snapBehaviourButton.tag = 3
        self.view.addSubview(snapBehaviourButton)
        
   
        let CollectionViewFlatButton = MDCFlatButton()
        CollectionViewFlatButton.customTitleColor = UIColor.gray
        CollectionViewFlatButton.setTitle("CollectionView", for: .normal)
        CollectionViewFlatButton.sizeToFit()
        CollectionViewFlatButton.center =  CGPoint(
            x: self.view.frame.width - (self.view.frame.width / 4),
            y: self.view.frame.height / 3
        )
        CollectionViewFlatButton.addTarget(self, action: #selector(self.onSender), for: .touchUpInside)
        CollectionViewFlatButton.tag = 4 // ボタン識別用ID
        self.view.addSubview(CollectionViewFlatButton)
        
        
        
        let floatingButton = MDCFloatingButton()
        floatingButton.setTitle("+", for: .normal)
        floatingButton.translatesAutoresizingMaskIntoConstraints = true
        floatingButton.sizeToFit()
        floatingButton.center = CGPoint(
                x: self.view.frame.width - (self.view.frame.width / 6),
                y: self.view.frame.height - (self.view.frame.height / 6)
            )
        floatingButton.addTarget(self, action: #selector(self.onPullModalShow), for: .touchUpInside)
        self.view.addSubview(floatingButton)
        
        
    }
    
    
    
    func onSender(sender: UIButton) {
        print(sender)
        print(sender.tag)
        
        
        switch sender.tag {
            case 1:
                let vc = ParticleViewController(titleName: "particle")
                navigationController?.pushViewController(vc, animated: true)

            case 2:
                let vc = stackBoxController(titleName: "stackBoxController")
                navigationController?.pushViewController(vc, animated: true)

            case 3:
                let vc = UIAnimation(titleName: "UIAnimation")
                navigationController?.pushViewController(vc, animated: true)

            case 4:
                let vc = CollectionViewController(titleName: "CollectionView")
                navigationController?.pushViewController(vc, animated: true)
            
            default: break

        }
        
    }
    
    func onMDCAlertShow() {
        let alertController = MDCAlertController(title: "Description", message: "This is sample APP")
        let action = MDCAlertAction(title:"OK") { (action) in
            print("OK")
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    

    func onPullModalShow() {
        let sb = UIStoryboard(name: "ModalViewController", bundle: nil)
        let nc = sb.instantiateInitialViewController() as! ModalNavigationController
        nc.interactor = interactor
        nc.transitioningDelegate = self
        present(nc, animated: true, completion: nil)
    }
    
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

