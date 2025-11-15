//
//  WelcomeView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Welcome to iCord")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            
            Text("Choose how you want to continue.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            
            Spacer()
            
            
            VStack(spacing: 12) {
                Button {
                    isFirstLaunch = false
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
                
                Button {
                    isFirstLaunch = false
                } label: {
                    Text("Continue in \(systemLanguageName())")
                        .frame(maxWidth: .infinity)
                }
                
            }
            .padding(.horizontal, 35)
            
            Spacer()
                .frame(height: 2)
            
            
        }
    }
    
    private func systemLanguageName() -> String {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        return Locale.current.localizedString(forLanguageCode: languageCode) ?? "System language"
    }
}

#Preview {
    WelcomeView()
}
