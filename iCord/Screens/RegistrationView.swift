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
            Text("profile_title")
                .font(.largeTitle.bold())

            Text("profile_subtitle")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)

            TextField("profile_placeholder", text: $displayName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 24)

            Spacer()

            Button {
                auth.completeProfile(name: displayName.trimmingCharacters(in: .whitespaces))
            } label: {
                let isEmpty = displayName.trimmingCharacters(in: .whitespaces).isEmpty
                
                Text("continue")
                    .font(.headline)
                    .foregroundColor(
                        isEmpty ? Color.secondary : Color.white
                    )
                    .padding(.vertical, 16)
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity)
                    .background(
                        displayName.trimmingCharacters(in: .whitespaces).isEmpty
                        ? Color.gray.opacity(0.3)
                        : Color.blue
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
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
