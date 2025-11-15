//
//  iCordApp.swift
//  iCord
//
//  Created by Денис on 14/11/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

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
