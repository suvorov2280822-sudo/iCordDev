//
//  CodeVerificationView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI
import UIKit

struct CodeVerificationView: View {
    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var smsCode: String = ""
    @State private var status: CodeFieldStatus = .normal
    @State private var isProcessing: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()

            Text("Enter code")
                .font(.largeTitle.bold())

            Text("We sent an SMS with a verification code to\n\(auth.phoneNumber)")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)

            CodeField(
                code: $smsCode,
                length: 6,
                status: status
            ) {
                verify()
            }
            .padding(.top, 8)

            if let error = auth.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Spacer()

            Button {
                verify()
            } label: {
                if isProcessing {
                    ProgressView()
                } else {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(smsCode.count < 6 || isProcessing)
            .padding(.horizontal, 70)
            .padding(.bottom, 32)
        }
        .navigationBarBackButtonHidden(true)
    }

    private func verify() {
        guard smsCode.count == 6 else { return }

        isProcessing = true
        status = .normal

        auth.verifyCode(smsCode) { success in
            isProcessing = false

            if success {
                withAnimation(.easeInOut) {
                    status = .success
                }
                // Лёгкий позитивный отклик
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } else {
                withAnimation(.easeInOut) {
                    status = .error
                }
                // Ошибка — короткая вибрация
                UINotificationFeedbackGenerator()
                    .notificationOccurred(.error)
            }
        }
    }
}

#Preview {
    CodeVerificationView()
        .environmentObject(AuthViewModel())
}
