//
//  CustomKeyboard.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/29.
//  Copyright © 2020 maycliao. All rights reserved.
//

import UIKit
import WebKit

protocol CustomKeyboardTargetProtocol: UIView {
    func input(text: String)    // 输入一个字符
    func backwards()            // delete
}

// 键盘字符及排版
enum CustomKeyboardMode {
    case normal         // 默认状态，显示小写字母
    case capsLock       // 显示大写字母
    case symbols        // 显示符号
    case moreSymbols    // 显示更多符号
    
    var characters: [String] {
        let letters = "q w e r t y u i o p a s d f g h j k l z x c v b n m"
        switch self {
        case .normal:
            return letters.components(separatedBy: " ")
        case .capsLock:
            return letters.uppercased().components(separatedBy: " ")
        case .symbols:
            let symbols = "1 2 3 4 5 6 7 8 9 0 - / : ; ( ) $ & @ \" . , ? ! '"
            return symbols.components(separatedBy: " ")
        case .moreSymbols:
            let moreSymbols = "[ ] { } # % ^ * + = _ \\ | ~ < > € £ ¥ • . , ? ! '"
            return moreSymbols.components(separatedBy: " ")
        }
    }
    
    var rowRanges: [Int] {
        switch self {
        case .normal, .capsLock:
            return [0, 10, 19, 26]
        case .symbols, .moreSymbols:
            return [0, 10, 20, 25]
        }
    }
    
    var shiftTitle: String? {
        switch self {
        case .symbols:
            return "#+="
        case .moreSymbols:
            return "123"
        default:
            return nil
        }
    }
    
    var shiftImage: UIImage? {
        switch self {
        case .normal:
            return #imageLiteral(resourceName: "capslock")
        case .capsLock:
            return #imageLiteral(resourceName: "capslock_fill")
        default:
            return nil
        }
    }
    
    var ctrlTitle: String {
        switch self {
        case .normal, .capsLock:
            return "123"
        case .symbols, .moreSymbols:
            return "ABC"
        }
    }
}

class CustomKeyboard: UIView {

    weak var targetView: CustomKeyboardTargetProtocol?
    
    var mode: CustomKeyboardMode = .normal
    
    private var characterButtons: [CustomKeyButton]?
    private var shiftButton: CustomKeyButton?
    private var ctrlButton: CustomKeyButton?
    
    private var currentPopButton: CustomKeyButton?
    
    let gapX: CGFloat = 7.0
    let gapY: CGFloat = 12.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x202122)
        self.reloadLayouts(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadLayouts(_ shouldReloadFuncKeys:Bool) {
        characterButtons?.forEach {
            $0.removeFromSuperview()
        }
        characterButtons = []
        
        let inputViewHeight = height - UIDevice.current.bottomAreaHeight
        let characters = mode.characters
        

        // 第一行
        var currentCharCount = mode.rowRanges[1] - mode.rowRanges[0]
        let keyHeight = (inputViewHeight - 4.0 * gapY) / 4.0
        let keyWidth = (width - CGFloat(currentCharCount) * gapX) / CGFloat(currentCharCount)
        for index in 0..<currentCharCount {
            let keyFrame = CGRect(x: 0.5 * gapX + (keyWidth + gapX) * CGFloat(index), y: 0.5 * gapY, width: keyWidth, height: keyHeight)
            let keyButton = CustomKeyButton(frame: keyFrame)
            keyButton.isUserInteractionEnabled = false
            keyButton.value = characters[index + mode.rowRanges[0]]
            if index == 0 {
                keyButton.popStyle = .left
            } else if index == 9 {
                keyButton.popStyle = .right
            }
            addSubview(keyButton)
            characterButtons?.append(keyButton)
        }
        
        // 第二行
        currentCharCount = mode.rowRanges[2] - mode.rowRanges[1]
        var charBeginX: CGFloat = currentCharCount == 10 ? 0.5 * gapX : (width - CGFloat(currentCharCount) * (keyWidth + gapX) + gapX) / 2.0

        for index in 0..<currentCharCount {
            let keyFrame = CGRect(x: charBeginX + (keyWidth + gapX) * CGFloat(index), y: 1.5 * gapY + keyHeight, width: keyWidth, height: keyHeight)
            let keyButton = CustomKeyButton(frame: keyFrame)
            keyButton.isUserInteractionEnabled = false
            keyButton.value = characters[index + mode.rowRanges[1]]
            if currentCharCount == 10 && index == 0 {
                keyButton.popStyle = .left
            } else if currentCharCount == 10 && index == 9 {
                keyButton.popStyle = .right
            }
            addSubview(keyButton)
            characterButtons?.append(keyButton)
        }
        
        // 第三行
        var currentY = 2.5 * gapY + 2 * keyHeight
        let shiftWidth = 1.3 * keyWidth
        if shouldReloadFuncKeys {
            shiftButton = CustomKeyButton(frame: CGRect(x: 0.5 * gapX, y: currentY, width: shiftWidth, height: keyHeight))
            shiftButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            shiftButton?.addTarget(self, action: #selector(shiftAction(_:)), for: .touchUpInside)
            addSubview(shiftButton!)
            
            let deleteButton = CustomKeyButton(frame: CGRect(x: width - 0.5 * gapX - shiftWidth, y: currentY, width: shiftWidth, height: keyHeight))
            deleteButton.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
            deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
            addSubview(deleteButton)
            
        }
        shiftButton?.setImage(mode.shiftImage, for: .normal)
        shiftButton?.setTitle(mode.shiftTitle, for: .normal)
        
        currentCharCount = mode.rowRanges[3] - mode.rowRanges[2]
        charBeginX = shiftWidth + 2 * gapX
        for index in 0..<currentCharCount {
            let currentKeyWidth = (width - 2 * charBeginX - CGFloat(currentCharCount - 1) * gapX) / CGFloat(currentCharCount)
            let keyFrame = CGRect(x: charBeginX + (currentKeyWidth + gapX) * CGFloat(index), y: currentY, width: currentKeyWidth, height: keyHeight)
            let keyButton = CustomKeyButton(frame: keyFrame)
            keyButton.isUserInteractionEnabled = false
            keyButton.value = characters[index + mode.rowRanges[2]]
            addSubview(keyButton)
            characterButtons?.append(keyButton)
        }
        
        // 第四行
        if shouldReloadFuncKeys {
            currentY = 3.5 * gapY + 3 * keyHeight
            let ctrlWidth = shiftWidth + keyWidth + 1.5 * gapX
            ctrlButton = CustomKeyButton(frame: CGRect(x: 0.5 * gapX, y: currentY, width: ctrlWidth, height: keyHeight))
            ctrlButton?.addTarget(self, action: #selector(ctrlAction(_:)), for: .touchUpInside)
            addSubview(ctrlButton!)
            
            let enterButton = CustomKeyButton(frame: CGRect(x: width - 0.5 * gapX - ctrlWidth, y: currentY, width: ctrlWidth, height: keyHeight))
            enterButton.value = "done"
            enterButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            enterButton.addTarget(self, action: #selector(enterAction(_:)), for: .touchUpInside)
            addSubview(enterButton)
            
            let spaceWidth = width - 2 * ctrlWidth - 3 * gapX
            let spaceButton = CustomKeyButton(frame: CGRect(x: ctrlWidth + 1.5 * gapX, y: currentY, width: spaceWidth, height: keyHeight))
            spaceButton.value = "我是自定义键盘"
            spaceButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            spaceButton.addTarget(self, action: #selector(spaceAction(_:)), for: .touchUpInside)
            addSubview(spaceButton)
        }
        ctrlButton?.setTitle(mode.ctrlTitle, for: .normal)
    }
    
    // MARK: - gesture
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self), let keyButtons = characterButtons else { return }
        
        for keyButton in keyButtons {
            // 这里为了扩大button的响应范围
            let hitTestFrame = CGRect(x: keyButton.x - 0.5 * gapX, y: keyButton.y - 0.5 * gapY, width: keyButton.width + gapX, height: keyButton.height + gapY)
            if hitTestFrame.contains(touchPoint) {
                currentPopButton?.hidePopView()
                bringSubviewToFront(keyButton)
                keyButton.showPopView()
                currentPopButton = keyButton
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchPoint = touches.first?.location(in: self), let keyButtons = characterButtons else { return }
        
        for keyButton in keyButtons {
            // 这里为了扩大button的响应范围
            let hitTestFrame = CGRect(x: keyButton.x - 0.5 * gapX, y: keyButton.y - 0.5 * gapY, width: keyButton.width + gapX, height: keyButton.height + gapY)
            if hitTestFrame.contains(touchPoint) {
                currentPopButton?.hidePopView()
                bringSubviewToFront(keyButton)
                keyButton.showPopView()
                currentPopButton = keyButton
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let value = currentPopButton?.value {
            targetView?.input(text: value)
            if mode == .capsLock {
                mode = .normal
                reloadLayouts(false)
            }
        }
        currentPopButton?.hidePopView()
        currentPopButton = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        currentPopButton?.hidePopView()
        currentPopButton = nil
    }
    
    // MARK: - Actions
    @objc func shiftAction(_: Any) {
        switch mode {
        case .normal:
            mode = .capsLock
        case .capsLock:
            mode = .normal
        case .symbols:
            mode = .moreSymbols
        case .moreSymbols:
            mode = .symbols
        }
        reloadLayouts(false)
    }
    
    @objc func ctrlAction(_: Any) {
        switch mode {
        case .normal, .capsLock:
            mode = .symbols
        case .symbols, .moreSymbols:
            mode = .normal
        }
        reloadLayouts(false)
    }
    
    @objc func spaceAction(_: Any) {
        targetView?.input(text: " ")
    }
    
    @objc func deleteAction(_: Any) {
        targetView?.backwards()
    }
    
    @objc func enterAction(_: Any) {
        hide()
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            if let container = self.superview {
                self.y = container.height
            }
        }) { _ in
            self.removeFromSuperview()
        }
        targetView?.resignFirstResponder()
    }
}
