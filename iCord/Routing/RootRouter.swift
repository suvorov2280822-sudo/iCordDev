//
//  RootRouter.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct RootRouter: View {
    @EnvironmentObject var auth: AuthViewModel
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @State private var showSplash: Bool = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
            } else {
                if auth.isLoggedIn {
                    if auth.needsProfile {
                        RegistrationView()
                    } else {
                        HomeView()
                    }
                } else {
                    if isFirstLaunch {
                        WelcomeView()
                    } else {
                        AuthFlowView()
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}
