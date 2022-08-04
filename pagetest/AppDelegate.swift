//
//  AppDelegate.swift
//  pagetest
//
//  Created by min on 2022/03/07.
//

import UIKit



@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var shouldSupportAllOrientation = true
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (shouldSupportAllOrientation == true){
            return UIInterfaceOrientationMask.all
            //  모든방향 회전 가능
        }
        return UIInterfaceOrientationMask.portrait
    }

}

