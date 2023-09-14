//
//  AppDelegate.swift
//  Example
//
//  Created by William.Weng on 2023/9/11.
//

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



