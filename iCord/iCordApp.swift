//
//  iCordApp.swift
//  iCord
//
//  Created by Денис on 14/11/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase
import UIKit


@main
struct iCordApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environmentObject(auth)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        FirebaseApp.configure()
        application.registerForRemoteNotifications()
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }

        completionHandler(.newData)
    }
}
