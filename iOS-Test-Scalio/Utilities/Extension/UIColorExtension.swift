//
//  UIColorExtension.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 14/12/2021.
//

import UIKit

enum AssetsColor {
   case viewBackgroundColor
   case cellBackgroundColor
}

extension UIColor {

    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .viewBackgroundColor:
            return UIColor(named: "ViewBackground")
        case .cellBackgroundColor:
            return UIColor(named: "CellBackgroundColor")
        }
    }
}
