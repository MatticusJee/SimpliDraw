//
//  DismissController.swift
//  SimpliDraw
//
//  Created by Matt Garofola on 2/1/19.
//  Copyright © 2019 Matt Garofola. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //        let to = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            from!.view.frame.origin.y = 800
            print("animating...")
        }) { (completed) -> Void in
            print("animate completed")
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
}
