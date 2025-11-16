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
            
            Text("welcome_title")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            
            Text("welcome_subtitle")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            
            Spacer()
            
            
            VStack(spacing: 12) {
                Button {
                    isFirstLaunch = false
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 30)
                }
                
                
                Button {
                    isFirstLaunch = false
                } label: {
                    Text(String(format: NSLocalizedString("continue_in_language", comment: ""),
                                systemLanguageName()
                        )
                    )
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
