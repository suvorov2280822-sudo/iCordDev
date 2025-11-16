//
//  AppDelegate.swift
//  iCord
//
//  Created by Денис on 16/11/2025.
//

import SwiftUI
import FirebaseCore
import Firebase
import UIKit

struct AppDelegates: View {
    @UIApplicationDelegateAdaptor(AppDelegate.celf) var delegate
    
    var body: some View {
    }
}

class AppDelete: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
    }
}
