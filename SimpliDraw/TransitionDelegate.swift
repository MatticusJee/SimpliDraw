//
//  TransitionDelegate.swift
//  SimpliDraw
//
//  Created by Matt Garofola on 2/1/19.
//  Copyright © 2019 Matt Garofola. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var currentViewController: UIViewController
    var presentingViewController: UIViewController
    
    init(viewController: UIViewController, presentingViewController: UIViewController) {
        self.currentViewController = viewController
        self.presentingViewController = presentingViewController
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresenterController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
}
