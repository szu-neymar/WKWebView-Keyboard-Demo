//
//  SolutionOneController.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/28.
//  Copyright © 2020 maycliao. All rights reserved.
//

import UIKit
import WebKit

class SolutionOneController: UIViewController {
    
    private let webView = SolutionOneWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "方案一"
        
        webView.frame = view.bounds
        view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: "https://ui.ptlogin2.qq.com/cgi-bin/login?style=9&appid=522005705&daid=4&s_url=https%3A%2F%2Fw.mail.qq.com%2Fcgi-bin%2Flogin%3Fvt%3Dpassport%26vm%3Dwsk%26delegate_url%3D%26f%3Dxhtml%26target%3D&hln_css=http%3A%2F%2Fmail.qq.com%2Fzh_CN%2Fhtmledition%2Fimages%2Flogo%2Fqqmail%2Fqqmail_logo_default_200h.png")!))
    }
    
}


class SolutionOneWebView: WKWebView {
    // 键盘输入视图
    var customKeyboard: CustomKeyboard?
    override var inputView: UIView? {
        return customKeyboard;
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        customKeyboard = CustomKeyboard(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300))
        customKeyboard?.targetView = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
