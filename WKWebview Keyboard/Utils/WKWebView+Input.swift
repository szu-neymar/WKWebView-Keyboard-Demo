//
//  WKWebView+Input.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/29.
//  Copyright © 2020 maycliao. All rights reserved.
//

import WebKit

extension WKWebView {
    // 输入字符，输入字符的位置取决于 WebView 当前焦点输入框光标的位置
    func input(text: String) {
        let script =
        """
        var currentInput = document.activeElement
        var start = currentInput.selectionStart
        var end = currentInput.selectionEnd
        var value = currentInput.value
        value = value.slice(0, start) + '\(text)' + value.slice(end)
        
        currentInput.value = value
        currentInput.setSelectionRange(start + 1, start + 1)
        """
        
        evaluateJavaScript(script, completionHandler: nil)
    }
    
    // delete按键
    func backwards() {
        let script =
        """
        var currentInput = document.activeElement
        var start = currentInput.selectionStart
        var end = currentInput.selectionEnd
        var value = currentInput.value
        if (start === end && start > 0) {
            value = value.slice(0, start - 1) + value.slice(start)
            currentInput.value = value
            currentInput.setSelectionRange(start - 1, start - 1)
        } else if (start !== end) {
            value = value.slice(0, start) + value.slice(end)
            currentInput.value = value
            currentInput.setSelectionRange(start, start)
        }
        
        
        """
        
        evaluateJavaScript(script, completionHandler: nil)
    }
}
