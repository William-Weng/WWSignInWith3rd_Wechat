//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

import UIKit
import WWSignInWith3rd_Apple
import WWSignInWith3rd_Wechat

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWSignInWith3rd.Wechat.shared.log { print($0) }
    }
    
    /// 微信登入
    /// - Parameter sender: UIButton
    @IBAction func signInWithWechat(_ sender: UIButton) {
        
        WWSignInWith3rd.Wechat.shared.login(presenting: self) { result in
            switch result {
            case .failure(let error): print(error)
            case .success(let info): print(info)
            }
        }
    }
}
