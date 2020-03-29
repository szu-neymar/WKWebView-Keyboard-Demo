//
//  ViewController.swift
//  WKWebview Keyboard
//
//  Created by Ken Liao on 2020/3/27.
//  Copyright © 2020 maycliao. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    private var cellReuseId: String { "cellReuseId" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Demo"
        
        let tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId)
        cell?.selectionStyle = .none
        if (indexPath.row == 0) {
            cell?.textLabel?.text = "方案一"
        } else {
            cell?.textLabel?.text = "方案二"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            navigationController?.pushViewController(SolutionOneController(), animated: true)
        } else {
            navigationController?.pushViewController(SolutionTwoController(), animated: true)
        }
    }
    
}


