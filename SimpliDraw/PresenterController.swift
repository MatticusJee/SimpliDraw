//
//  PresenterController.swift
//  SimpliDraw
//
//  Created by Matt Garofola on 2/1/19.
//  Copyright © 2019 Matt Garofola. All rights reserved.
//

import UIKit

class PresenterController: UIPresentationController {
    
    var _dimmingView: UIView?
    var panGestureRecognizer = UIPanGestureRecognizer()
    var tapRecognizer = UITapGestureRecognizer()
    var direction: CGFloat = 0
    
    let contentHeight: [CGFloat: CGFloat] = [568.0: 350, 667.0: 270, 736.0: 270, 812.0: 270, 896: 280]
    
    var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            return dimmedView
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        view.addSubview(blurEffectView)
        
        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = view.bounds
        
        // Add the vibrancy view to the blur view
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        _dimmingView = view
        
        //Allow to dismiss when touched outside contentView
        tapRecognizer = UITapGestureRecognizer(target: self, action: nil)
        tapRecognizer.delegate = self
        view.addGestureRecognizer(tapRecognizer)
        return view
    }

    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        //presentingViewController = root view controller
        //presentedViewController = new view controller
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let modelHeight = contentHeight[containerView!.bounds.height]!
        return CGRect(x: 0, y: containerView!.bounds.height - modelHeight, width: containerView!.bounds.width, height: modelHeight)
    }
    
    override func presentationTransitionWillBegin() {
        let dimmedView = dimmingView
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            dimmedView.alpha = 0
            containerView.addSubview(dimmedView)
            dimmedView.addSubview(presentedViewController.view)
            coordinator.animate(alongsideTransition: { (context) -> Void in
                dimmedView.alpha = 1
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { (context) -> Void in
            }, completion: { (completed) -> Void in
                print("done dismiss animation")
            })
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            _dimmingView = nil
        }
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) -> Void {
        let endPoint = pan.translation(in: pan.view?.superview)
        switch pan.state {
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height
        case .changed:
            let velocity = pan.velocity(in: pan.view?.superview)
            presentedView!.frame.origin.y = endPoint.y + containerView!.frame.height / 2
            direction = velocity.y
            break
        case .ended:
            if direction <= 0 {
                changeScale()
            }
            else {
                presentedViewController.dismiss(animated: true, completion: nil)
            }
            print("finished transition")
            break
        default:
            break
        }
    }
    
    func changeScale() {
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
                presentedView.frame = containerView.frame
                let containerFrame = containerView.frame
                let halfFrame = CGRect(origin: CGPoint(x: 0, y: containerFrame.height / 2), size: CGSize(width: containerFrame.width, height: containerFrame.height / 2))
                let frame = halfFrame
                presentedView.frame = frame
                if let navController = self.presentedViewController as? UINavigationController {
                    navController.setNeedsStatusBarAppearanceUpdate()
                }
            }, completion: { (isFinished) in
                print("Scale Changed")
            })
        }
    }
    
}

extension PresenterController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        presentedViewController.dismiss(animated: true, completion: nil)
        return true
    }
}
