//
//  SolutionTwoController.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/28.
//  Copyright © 2020 maycliao. All rights reserved.
//

import UIKit
import WebKit

class SolutionTwoController: UIViewController {

    private let webView = SolutionTwoWebView()
    private var isPasswordInputOnFocus = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "方案二"

        webView.frame = view.bounds
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: "https://ui.ptlogin2.qq.com/cgi-bin/login?style=9&appid=522005705&daid=4&s_url=https%3A%2F%2Fw.mail.qq.com%2Fcgi-bin%2Flogin%3Fvt%3Dpassport%26vm%3Dwsk%26delegate_url%3D%26f%3Dxhtml%26target%3D&hln_css=http%3A%2F%2Fmail.qq.com%2Fzh_CN%2Fhtmledition%2Fimages%2Flogo%2Fqqmail%2Fqqmail_logo_default_200h.png")!))
        
        // 监听键盘唤起事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.resignFirstResponder()
    }
    
    // MARK: - Keyboard Intercept
    @objc func keyboardWillShow(_: NSNotification) {
        var keyboardWindow: UIWindow?
        for window in UIApplication.shared.windows {
            if window.description.contains("UIRemoteKeyboardWindow") {
                keyboardWindow = window
                break
            }
        }
        
        guard let kbWindow = keyboardWindow else { return }
        
        guard isPasswordInputOnFocus else {
            for subview in kbWindow.subviews {
                if subview.isKind(of: CustomKeyboard.self) {
                    self.reloadSystemKeyboard(with: keyboardWindow)
                    break
                }
            }
            return
        }
        
        kbWindow.subviews.forEach {
            $0.isHidden = true
        }
        
        let customKeyboard = CustomKeyboard(frame: CGRect(x: 0, y: kbWindow.bounds.height - 300, width: kbWindow.bounds.width, height: 300))
        customKeyboard.targetView = self.webView
        kbWindow.addSubview(customKeyboard)
    }
    
    func reloadSystemKeyboard(with keyboardWindow: UIWindow?) {
        keyboardWindow?.subviews.forEach {
            if ($0.isKind(of: CustomKeyboard.self)) {
                $0.removeFromSuperview()
            } else {
                $0.isHidden = false
            }
        }
    }
}

extension SolutionTwoController: WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        injectScripts()
        decisionHandler(.allow)
    }
    
    // 注入密码框监听脚本
    func injectScripts() {
        let scripts =
        """
        password = document.getElementById("p")

        password.addEventListener('focus', onFocus)
        password.addEventListener('blur', onBlur)
        password.addEventListener('input', updateValue)

        function onFocus(e) {
            callNative('password.focus')
        }

        function onBlur(e) {
            callNative('password.blur')
        }

        function callNative(message) {
            alert(message) // 这里选择 alert 的方式与原生通信
        }
        """
        
        webView.evaluateJavaScript(scripts, completionHandler: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(message)
        // 密码框对焦，即开始输入，即将会弹出系统键盘
        if message == "password.focus" {
            isPasswordInputOnFocus = true
        }
        // 密码框失焦，可能是点击了其他编辑框或收起了键盘
        else if message == "password.blur" {
            isPasswordInputOnFocus = false
        }
        completionHandler()
    }
}

class SolutionTwoWebView: WKWebView {
    override var inputAccessoryView: UIView? {
        return nil
    }
}
