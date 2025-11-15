//
//  RegistrationView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct RegistrationView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var displayName: String = ""

    var body: some View {
        VStack(spacing: 24) {
            Text("Profile")
                .font(.largeTitle.bold())

            Text("Enter your name to finish setting up your account.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)

            TextField("Name", text: $displayName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)

            Spacer()

            Button {
                auth.completeProfile(name: displayName.trimmingCharacters(in: .whitespaces))
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(displayName.trimmingCharacters(in: .whitespaces).isEmpty)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    RegistrationView()
}
