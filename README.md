# WWSignInWith3rd+Wechat

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-14.0](https://img.shields.io/badge/iOS-14.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![](https://img.shields.io/github/v/tag/William-Weng/WWSignInWith3rd_Wechat) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

[Use Wechat third-party login.](https://github.com/yanyin1986/WechatOpenSDK)

[使用微信的第三方登入。](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html)

![](./Example.gif)

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```js
dependencies: [
    .package(url: "https://github.com/William-Weng/WWSignInWith3rd_Wechat.git", .upToNextMajor(from: "1.0.0"))
]
```

### Example
```swift
import UIKit
import WWSignInWith3rd_Apple
import WWSignInWith3rd_Wechat

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return WWSignInWith3rd.Wechat.shared.configure(appId: "<WechatAppId>", secret: "<WechatSecret>", universalLink: "<UniversalLink>")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return WWSignInWith3rd.Wechat.shared.canOpenURL(app, open: url)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WWSignInWith3rd.Wechat.shared.canOpenUniversalLink(application, continue: userActivity, restorationHandler: restorationHandler)
    }
}
```
```swift
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
```
