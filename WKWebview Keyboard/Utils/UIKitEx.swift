//
//  UIViewEx.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/29.
//  Copyright © 2020 maycliao. All rights reserved.
//

import UIKit

extension UIView {
    
    var x: CGFloat {
        get {
            frame.origin.x
        }
        set {
            var newFrame = frame
            newFrame.origin.x = newValue
            frame = newFrame
        }
    }
    
    var y: CGFloat {
        get {
            frame.origin.y
        }
        set {
            var newFrame = frame
            newFrame.origin.y = newValue
            frame = newFrame
        }
    }
    
    var width: CGFloat {
        get {
            frame.width
        }
        set {
            var newFrame = frame
            newFrame.size.width = newValue
            frame = newFrame
        }
    }
    
    var height: CGFloat {
        get {
            frame.height
        }
        set {
            var newFrame = frame
            newFrame.size.height = newValue
            frame = newFrame
        }
    }
}

extension UIColor {
    
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}

extension UIDevice {
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var bottomAreaHeight: CGFloat {
        isNotch ? 44 : 0
    }
    
    var isNotch: Bool {
        let window = UIApplication.shared.windows.filter{$0.isKeyWindow}.first
        if let bottom = window?.safeAreaInsets.bottom {
            return bottom > 0
        }
        return false
    }
}
