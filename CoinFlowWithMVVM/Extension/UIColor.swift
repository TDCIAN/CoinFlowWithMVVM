//
//  UIColor.swift
//  CoinFlowWithMVVM
//
//  Created by APPLE on 2021/01/06.
//

import UIKit

extension UIColor {
    static func randomColor() -> UIColor {
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemTeal, .systemGreen, .systemYellow, .systemOrange]
        
        let randomColor = colors.randomElement()!
        return randomColor
    }
}
