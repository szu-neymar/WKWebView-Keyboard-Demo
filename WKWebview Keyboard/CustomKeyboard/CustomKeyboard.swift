//
//  CustomKeyboard.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/28.
//  Copyright © 2020 maycliao. All rights reserved.
//

import UIKit
import WebKit

class CustomKeyboard: UIView {
        
    weak var targetView: UIView?
    
    var margin: CGFloat { 20 }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .darkGray
        createKeys()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createKeys() {
        let keyWidth = (self.bounds.width - 3 * margin) / 2.0
        let keyHeight = (self.bounds.height - 3 * margin) / 2.0
        
        var frame = CGRect(x: margin, y: margin, width: keyWidth, height: keyHeight)
        createLetterButton(frame: frame, value: "a")
        frame.origin.x = keyWidth + 2 * margin
        createLetterButton(frame: frame, value: "b")
        frame.origin.y = keyHeight + 2 * margin
        createDeleteButton(frame: frame)
        frame.origin.x = margin
        createLetterButton(frame: frame, value: "c")
    }
    
    private func createLetterButton(frame: CGRect, value: String) {
        let button = UIButton(frame: frame)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.setTitle(value, for: .normal)
        button.addTarget(self, action: #selector(inputAction(_:)), for: .touchUpInside)
        addSubview(button)
    }
    
    private func createDeleteButton(frame: CGRect) {
        let button = UIButton(frame: frame)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.setTitle("Del", for: .normal)
        button.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        addSubview(button)
    }
    
    @objc func inputAction(_ button: UIButton) {
        guard let value = button.titleLabel?.text else { return }
        if let webView = targetView as? WKWebView {
            webView.input(text: value)
        }
    }
    
    @objc func deleteAction(_ button: UIButton) {
        if let webView = targetView as? WKWebView {
            webView.backwards()
        }
    }
    
}
