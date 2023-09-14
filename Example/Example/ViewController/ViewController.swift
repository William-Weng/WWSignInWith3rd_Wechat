//
//  ViewController.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//  ~/Library/Caches/org.swift.swiftpm/

import UIKit
import WWPrint
import WWSignInWith3rd_Apple
import WWSignInWith3rd_Wechat

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWSignInWith3rd.Wechat.shared.log { wwPrint($0) }
    }
    
    /// [設定Build Settings -> Other Linker Flags => -ObjC -all_load](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html)
    /// - Parameter sender: UIButton
    @IBAction func signInWithWechat(_ sender: UIButton) {
        
        WWSignInWith3rd.Wechat.shared.login(presenting: self) { result in
            
            switch result {
            case .failure(let error): wwPrint(error)
            case .success(let info): wwPrint(info)
            }
        }
    }
}
