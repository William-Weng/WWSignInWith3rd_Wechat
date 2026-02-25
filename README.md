# [WWSignInWith3rd+Wechat](https://github.com/William-Weng?tab=repositories&q=+WWSignInWith3rd)

[![Swift-5.7](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat)](https://developer.apple.com/swift/) [![iOS-15.0](https://img.shields.io/badge/iOS-15.0-pink.svg?style=flat)](https://developer.apple.com/swift/) ![](https://img.shields.io/github/v/tag/William-Weng/WWSignInWith3rd_Wechat) [![Swift Package Manager-SUCCESS](https://img.shields.io/badge/Swift_Package_Manager-SUCCESS-blue.svg?style=flat)](https://developer.apple.com/swift/) [![LICENSE](https://img.shields.io/badge/LICENSE-MIT-yellow.svg?style=flat)](https://developer.apple.com/swift/)

### [Introduction - 簡介](https://swiftpackageindex.com/William-Weng)
- [Use Wechat third-party login.](https://github.com/yanyin1986/WechatOpenSDK)
- [使用微信的第三方登入。](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html)

https://github.com/user-attachments/assets/1080bb1a-d4d6-4051-8098-3dca321a7b36

### [Installation with Swift Package Manager](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/使用-spm-安裝第三方套件-xcode-11-新功能-2c4ffcf85b4b)
```js
dependencies: [
    .package(url: "https://github.com/William-Weng/WWSignInWith3rd_Wechat.git", .upToNextMajor(from: "1.2.1"))
]
```

### 必要設定
#### info.plist
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>wechat</string>
    <string>weixin</string>
    <string>weixinUL</string>
    <string>weixinULAPI</string>
    <string>weixinURLParamsAPI</string>
</array>

<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLName</key>
		<string>Wechat</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>&lt;WechatAppId&gt;</string>
		</array>
	</dict>
</array>
```

![](https://github.com/user-attachments/assets/a656cf7d-0ef2-4c21-9ba6-765901018d3b)

![](https://github.com/user-attachments/assets/ddbed636-0b3b-4802-b1d9-6ef76e33149b)

### Function - 可用函式
|函式|功能|
|-|-|
|configure(appId:secret:universalLink:)|線上註冊參數|
|login(presenting:requestAction:completionAction:)|登入 - 網頁 / APP|
|logout()|沒有登出功能|
|openMiniProgram(with:path:type:completion:)|開啟微信小程序|
|canOpenURL(_:)|在外部由URL Scheme開啟|
|canOpenUniversalLink(userActivity:)|在外部由UniversalLink開啟|
|log(level:result:)|印出Log訊息|

### Example
#### SceneDelegate.swift
```swift
import UIKit
import WWSignInWith3rd_Apple
import WWSignInWith3rd_Wechat

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        _ = WWSignInWith3rd.Wechat.shared.configure(appId: "<WechatAppId>", secret: "<WechatSecret>", universalLink: "<UniversalLink>")
    }
}

extension SceneDelegate {
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        _ = WWSignInWith3rd.Wechat.shared.canOpenURL(urlContext.url)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        _ = WWSignInWith3rd.Wechat.shared.canOpenUniversalLink(userActivity: userActivity)
    }
}
```
```swift
import UIKit
import WWSignInWith3rd_Apple
import WWSignInWith3rd_Wechat

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WWSignInWith3rd.Wechat.shared.log { print($0) }
    }
    
    @IBAction func signInWithWechat(_ sender: UIButton) {
        
        WWSignInWith3rd.Wechat.shared.login(presenting: self) { result in
            
            switch result {
            case .failure(let error): print(error)
            case .success(let info): print(info)
            }
        }
    }
}
```
