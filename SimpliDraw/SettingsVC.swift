//
//  SettingsVC.swift
//  SimpliDraw
//
//  Created by Matt Garofola on 2/1/19.
//  Copyright © 2019 Matt Garofola. All rights reserved.
//

import UIKit

//Delegate for SettingVC to pass back selected color back to first VC
protocol ColorSelectorDelegate: class {
    func selectedColor(_ color: UIColor)
}

class SettingsVC: UIViewController {
    
    weak var delegate: ColorSelectorDelegate?
    
    let colorSelection: [UIColor] = [.red, .orange, .yellow, .green, .blue, .purple, .gray, .black, .brown, .white, .magenta, .cyan]
}

extension SettingsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorSelection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        guard let colorView = cell.contentView.viewWithTag(5) else { return UICollectionViewCell() }
        // Make each view into a circle
        colorView.layer.borderWidth = 1
        colorView.layer.masksToBounds = false
        colorView.layer.cornerRadius = colorView.frame.height / 2
        colorView.clipsToBounds = true
        //Set the color
        colorView.backgroundColor = colorSelection[indexPath.row]
        colorView.layer.borderColor = colorSelection[indexPath.row].cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        let colorView = cell.contentView.viewWithTag(5)
        let colorSelected = colorView!.backgroundColor!
        self.dismiss(animated: true) {
            //Pass color back to first view controller
            self.delegate?.selectedColor(colorSelected)
        }
    }
}
