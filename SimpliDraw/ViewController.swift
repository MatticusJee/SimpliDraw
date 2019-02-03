//
//  ViewController.swift
//  SimpliDraw
//
//  Created by Matt Garofola on 2/1/19.
//  Copyright © 2019 Matt Garofola. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backDrawingBox: UIImageView!
    @IBOutlet weak var tempDrawingBox: UIImageView!
    
    var transitionDelegate: TransitionDelegate?
    
    var lineWidth: CGFloat = 5.0
    var lastPoint = CGPoint.zero
    var color: UIColor = .black {
        didSet {
            self.navigationController?.navigationBar.barTintColor = color
            if(color == .black) {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
            else {
                self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.color = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let settingsVC = segue.destination as? SettingsVC else { return }
        settingsVC.delegate = self
        self.transitionDelegate = TransitionDelegate(viewController: self, presentingViewController: settingsVC)
        settingsVC.modalPresentationStyle = .custom
        settingsVC.transitioningDelegate = self.transitionDelegate
    }
    
    @IBAction func clearBox(_ sender: Any) {
        backDrawingBox.image = nil
    }
    
    @IBAction func changeColor(_ sender: Any) {
        self.performSegue(withIdentifier: "ChangeSettingsSegue", sender: nil)
    }
}

extension ViewController: ColorSelectorDelegate {
    
    func selectedColor(_ color: UIColor) {
        self.color = color
    }
}

// Touch Events
extension ViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: tempDrawingBox)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: tempDrawingBox)
        drawLine(startPoint: lastPoint, endPoint: currentPoint)
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIGraphicsBeginImageContext(backDrawingBox.frame.size)
        backDrawingBox.image?.draw(in: backDrawingBox.bounds, blendMode: .normal, alpha: 1.0)
        tempDrawingBox?.image?.draw(in: tempDrawingBox.bounds, blendMode: .normal, alpha: 1.0)
        backDrawingBox.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        tempDrawingBox.image = nil
    }
    
    
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) {
        UIGraphicsBeginImageContext(tempDrawingBox.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        tempDrawingBox.image?.draw(in: tempDrawingBox.bounds)
        context.move(to: startPoint)
        context.addLine(to: endPoint)
        context.setLineCap(.round)
        context.setBlendMode(.normal)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color.cgColor)
        context.strokePath()
        tempDrawingBox.image = UIGraphicsGetImageFromCurrentImageContext()
        tempDrawingBox.alpha = 1.0
        UIGraphicsEndImageContext()
    }
}

