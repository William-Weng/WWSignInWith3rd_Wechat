//
//  WWSignInWith3rd_Wechat.swift
//  WWSignInWith3rd_Wechat
//
//  Created by William.Weng on 2023/9/13.
//

import UIKit
import WWSignInWith3rd_Apple
import WechatOpenSDK

// MARK: - 第三方登入
extension WWSignInWith3rd {
    
    /// [WechatOpenSDK - 2.0.7](https://github.com/yanyin1986/WechatOpenSDK)
    open class Wechat: NSObject {
        
        public static let shared = Wechat()
        
        private(set) var appId: String?
        private(set) var secret: String?
        private(set) var universalLink: String?
        private(set) var code: String?
        
        private var requestBlock: ((BaseReq) -> Void)?
        private var completionBlock: ((Result<[String: Any]?, Error>) -> Void)?

        private override init() {}
    }
}

extension WWSignInWith3rd.Wechat: WXApiDelegate {}
extension WWSignInWith3rd.Wechat: UIAdaptivePresentationControllerDelegate {}

// MARK: - WXApiDelegate
public extension WWSignInWith3rd.Wechat {
    
    func onReq(_ req: BaseReq) { requestBlock?(req) }
    func onResp(_ resp: BaseResp) { loginInformation(with: resp) }
}

// MARK: - UIAdaptivePresentationControllerDelegate
public extension WWSignInWith3rd.Wechat {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.completionBlock?(.failure(WWSignInWith3rd.CustomError.isCancel))
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .automatic
    }
}

// MARK: - 公開函式
public extension WWSignInWith3rd.Wechat {
    
    /// [線上註冊參數](https://asueliu.pixnet.net/blog/post/67956720-[微信小程序]-ios跳轉到微信小程序(swift))
    /// - [Build Setting -> Other Linker Flags => "-ObjC -all_load"](https://www.jianshu.com/p/1c1018580a58)
    /// - [<key>LSApplicationQueriesSchemes</key><array><string>wechat</string><string>weixin</string></array>](https://www.jianshu.com/p/7d45f5ce2460)
    /// - Parameters:
    ///   - appid: [微信．開放平臺上註冊的AppID - 要繳錢](https://open.weixin.qq.com/)
    ///   - universalLink: [Universal Links](https://search.developer.apple.com/appsearch-validation-tool/)
    /// - Returns: [Bool](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Access_Guide/iOS.html)
    func configure(appId: String, secret: String, universalLink: String) -> Bool {
        
        let isSuccess = WXApi.registerApp(appId, universalLink: universalLink)
        
        requestBlock = nil
        completionBlock = nil
        
        if (isSuccess) {
            self.appId = appId
            self.secret = secret
            self.universalLink = universalLink
        }
        
        return isSuccess
    }
    
    /// [登入 - 網頁 / APP](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Share_and_Favorites/iOS.html)
    /// - Parameters:
    ///   - viewController: [UIViewController](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/ios-13-的-present-modally-變成更方便的卡片設計-fb6b31f0e20e)
    ///   - state: 唯一碼
    ///   - requestAction: [((BaseReq) -> Void)?](https://www.jianshu.com/p/1b744a97e63d)
    ///   - completionAction: ((Result<[String: Any]?, Error>) -> Void)?
    func login(presenting viewController: UIViewController, state: String = "3939889", requestAction: ((BaseReq) -> Void)? = nil, completionAction: ((Result<[String: Any]?, Error>) -> Void)?) {
        
        let request = SendAuthReq()
        
        request.scope = "snsapi_userinfo"
        request.state = state
        
        requestBlock = requestAction
        completionBlock = completionAction
                
        WXApi.sendAuthReq(request, viewController: viewController, delegate: self) { isSuccess in
           
            if (!isSuccess) { self.completionBlock?(.failure(WWSignInWith3rd.CustomError.unknown)) }
            
            guard let presentedViewController = viewController.presentedViewController as? UINavigationController,
                  let presentationController = presentedViewController.presentationController
            else {
                return
            }
            
            presentedViewController.view.tintColor = .systemBlue
            presentationController.delegate = self
        }
    }
    
    /// 沒有登出功能
    func logout() { fatalError("沒有登出功能") }
    
    /// [開啟微信小程序](https://asueliu.pixnet.net/blog/post/67956720-[微信小程序]-ios跳轉到微信小程序(swift))
    /// - Parameters:
    ///   - identifier: [該微信小程序的ID](https://kknews.cc/zh-tw/tech/r33or8v.html)
    ///   - path: path description
    ///   - type: WXMiniProgramType
    ///   - completion: (Bool)
    func openMiniProgram(with identifier: String, path: String? = nil, type: WXMiniProgramType = .release, completion: ((Bool) -> Void)?) {
        
        let request = WXLaunchMiniProgramReq.object()
        
        request.userName = identifier
        request.miniProgramType = type
        request.path = path
        
        WXApi.send(request) { isSuccess in
            completion?(isSuccess)
        }
    }
    
    /// [在外部由URL Scheme開啟](https://www.hangge.com/blog/cache/detail_1042.html)
    /// - Parameters:
    ///   - app: [UIApplication](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/Launching_a_Mini_Program/iOS_Development_example.html)
    ///   - url: [URL](https://www.ctolib.com/topics-132328.html)
    /// - Returns: [Bool](https://www.imtqy.com/MiniProgram-navigate.html)
    func canOpenURL(_ url: URL) -> Bool {
        
        guard let appid = appId,
              url.absoluteString.contains(appid)
        else {
            return true
        }
        
        return WXApi.handleOpen(url, delegate: self)
    }
    
    /// [在外部由UniversalLink開啟](https://blog.csdn.net/mo_xiao_mo/article/details/60954116)
    /// - Parameters:
    ///   - userActivity: NSUserActivity
    /// - Returns: Bool
    func canOpenUniversalLink(userActivity: NSUserActivity) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self)
    }
    
    /// [印出Log訊息](https://franksios.medium.com/ios-如何在-swift-專案中使用-objective-c-的函式庫或檔案-943de5a8c71)
    func log(level: WXLogLevel = .detail, result: ((String) -> Void)?) {
        
        WXApi.startLog(by: level) { log in
            result?(log)
        }
    }
}

// MARK: - 小工具
private extension WWSignInWith3rd.Wechat {
    
    /// 取得Login後的相關資訊 (確認 / 取消)
    /// - Parameter response: [BaseResp](https://developers.weixin.qq.com/doc/oplatform/Mobile_App/WeChat_Login/Development_Guide.html)
    func loginInformation(with response: BaseResp) {
        
        guard let response = response as? SendAuthResp,
              response.errStr.isEmpty,
              let code = response.code
        else {
            self.completionBlock?(.failure(WWSignInWith3rd.CustomError.isCancel)); return
        }
        
        self.code = code
        
        DispatchQueue(label: "WechatLoginDispatchQueue").async {
            
            guard let data = self.responseData(with: code),
                  let jsonObject = data._jsonObject()
            else {
                self.completionBlock?(.success(nil)); return
            }
            
            self.completionBlock?(.success(jsonObject as? [String: Any]))
        }
    }
    
    /// [通過Code獲取相關資訊 - HTML](https://developers.weixin.qq.com/doc/oplatform/Website_App/WeChat_Login/Authorized_Interface_Calling_UnionID.html)
    /// - {"access_token":"ACCESS_TOKEN","expires_in":7200,"refresh_token":"REFRESH_TOKEN","openid":"OPENID","scope":"SCOPE"}
    /// - Parameter code: [由Response回傳的Token](https://www.jianshu.com/p/f098ff0ad6b9)
    /// - Returns: [Data?](https://blog.csdn.net/qq_39848087/article/details/102686152)
    func responseData(with code: String) -> Data? {

        guard let url = accessTokenURL(with: code),
              let data = try? Data(contentsOf: url, options: .alwaysMapped)
        else {
            return nil
        }
        
        return data
    }
    
    /// 產生AccessTokenURL
    /// - Parameter code: 由Response回傳的Token
    /// - Returns: URL?
    func accessTokenURL(with code: String) -> URL? {
        
        guard let appid = appId,
              let secret = secret,
              let urlString = Optional.some("https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(appid)&secret=\(secret)&code=\(code)&grant_type=authorization_code"),
              let url = URL(string: urlString)
        else {
            return nil
        }
        
        return url
    }
}
