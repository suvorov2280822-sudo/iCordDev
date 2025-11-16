//
//  iCordApp.swift
//  iCord
//
//  Created by Денис on 14/11/2025.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseAppCheck
import UIKit



@main
struct iCordApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var auth = AuthViewModel()
    
    init() {
            FirebaseApp.configure()
            
            // ВАЖНО: включаем app delegate proxy
            Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        }

    var body: some Scene {
        WindowGroup {
            RootRouter()
                .environmentObject(auth)
        }
    }
}
