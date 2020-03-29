//
//  CustomKeyButton.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/29.
//  Copyright © 2020 maycliao. All rights reserved.
//

import UIKit

class CustomKeyButton: UIButton {
    
    var popStyle: CustomKeyPopView.Style = .inner
    
    private var popView: CustomKeyPopView?
    
    
    var value: String? {
        get {
            title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x414243)
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        layer.cornerRadius = 6
        setTitleColor(UIColor(hex: 0xFDFEFF), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showPopView() {
        if popView != nil {
            popView?.isHidden = false
        } else {
            let cornerRadius: CGFloat = 6.0
            var frame = CGRect(x: -2 * cornerRadius, y: -(height + cornerRadius), width: width + 4 * cornerRadius, height: 2 * height + cornerRadius)
            if popStyle == .left {
                frame.origin.x = 0
                frame.size.width = width + 2 * cornerRadius
            } else if popStyle == .right {
                frame.size.width = width + 2 * cornerRadius
            }
            
            popView = CustomKeyPopView(frame: frame, style: popStyle, title: value)
            addSubview(popView!)
        }
    }
    
    func hidePopView() {
        popView?.isHidden = true
    }
}

class CustomKeyPopView: UIView {
    enum Style {
        case left
        case right
        case inner
    }
    
    var style: Style = .inner
    
    convenience init(frame: CGRect, style: Style, title: String?) {
        self.init(frame: frame)
        self.style = style
        drawBackground()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: width))
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = UIColor(hex: 0xFDFEFF)
        label.text = title
        label.textAlignment = .center
        addSubview(label)
    }
    
    private func drawBackground() {
        let cornerRadius: CGFloat = 6.0
        var keyWidth = width - 2 * cornerRadius
        let keyHeight: CGFloat = (height - cornerRadius) / 2.0
        if style == .inner { keyWidth = keyWidth - 2 * cornerRadius }
     
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: cornerRadius))
        bezierPath.addQuadCurve(to: CGPoint(x: cornerRadius, y: 0), controlPoint: CGPoint.zero)
        bezierPath.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
        bezierPath.addQuadCurve(to: CGPoint(x: width, y: cornerRadius), controlPoint: CGPoint(x: width, y: 0))
        
        switch style {
        case .inner, .left:
            bezierPath.addLine(to: CGPoint(x: width, y: keyHeight + cornerRadius))
            bezierPath.addCurve(to: CGPoint(x: width - 2 * cornerRadius, y: keyHeight + 3 * cornerRadius),
                                controlPoint1: CGPoint(x: width, y: keyHeight + 2 * cornerRadius),
                                controlPoint2: CGPoint(x: width - 2 * cornerRadius, y: keyHeight + 2 * cornerRadius))
            bezierPath.addLine(to: CGPoint(x: width - 2 * cornerRadius, y: height - cornerRadius))
            bezierPath.addQuadCurve(to: CGPoint(x: width - 3 * cornerRadius, y: height),
                                    controlPoint: CGPoint(x: width - 2 * cornerRadius, y: height))
            
            bezierPath.addLine(to: CGPoint(x: width - keyWidth - cornerRadius, y: height))
            bezierPath.addQuadCurve(to: CGPoint(x: width - keyWidth - 2 * cornerRadius, y: height - cornerRadius),
                                    controlPoint: CGPoint(x: width - keyWidth - 2 * cornerRadius, y: height))
            
            if (style == .inner) {
                bezierPath.addLine(to: CGPoint(x: 2 * cornerRadius, y: height - keyHeight + 2 * cornerRadius))
                bezierPath.addCurve(to: CGPoint(x: 0, y: keyHeight + cornerRadius),
                                    controlPoint1: CGPoint(x: 2 * cornerRadius, y: keyHeight + 2 * cornerRadius),
                                    controlPoint2: CGPoint(x: 0, y: keyHeight + 2 * cornerRadius))
                
            }
            bezierPath.addLine(to: CGPoint(x: 0, y: cornerRadius))
            
        case .right:
            bezierPath.addLine(to: CGPoint(x: width, y: height - cornerRadius))
            bezierPath.addQuadCurve(to: CGPoint(x: width - cornerRadius, y: height),
                                    controlPoint: CGPoint(x: width, y: height))
            bezierPath.addLine(to: CGPoint(x: 3 * cornerRadius, y: height))
            bezierPath.addQuadCurve(to: CGPoint(x: 2 * cornerRadius, y: height - cornerRadius),
                                    controlPoint: CGPoint(x: 2 * cornerRadius, y: height))
            
            bezierPath.addLine(to: CGPoint(x: 2 * cornerRadius, y: height - keyHeight + 2 * cornerRadius))
            bezierPath.addCurve(to: CGPoint(x: 0, y: keyHeight + cornerRadius),
                                controlPoint1: CGPoint(x: 2 * cornerRadius, y: keyHeight + 2 * cornerRadius),
                                controlPoint2: CGPoint(x: 0, y: keyHeight + 2 * cornerRadius))
            bezierPath.addLine(to: CGPoint(x: 0, y: cornerRadius))
        }
        
        let shapeLayer = CAShapeLayer();
        shapeLayer.fillColor = UIColor(hex: 0x414243).cgColor
        shapeLayer.strokeColor = UIColor(hex: 0x2D2E2F).cgColor
        shapeLayer.path = bezierPath.cgPath
        layer.addSublayer(shapeLayer)
    }
}
