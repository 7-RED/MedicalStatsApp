//
//  FirebaseAuth.swift
//  practice
//
//  Created by 陳其宏 on 2021/6/14.
//

import SwiftUI
import Firebase

@main struct FirebaseAuth: App{
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene{
        WindowGroup{
            let viewModel = AppviewModel()
            ContentView().environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject,UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
}
