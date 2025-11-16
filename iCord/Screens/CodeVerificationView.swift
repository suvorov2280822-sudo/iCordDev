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

            // BACK BUTTON
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.backward")
                        Text("back_button")
                            .foregroundColor(.black)
                    }
                }
                Spacer()
            }
            .padding(.horizontal)

            Spacer()

            Text("code_title")
                .font(.largeTitle.bold())

            Text(String(format: NSLocalizedString("code_subtitle", comment: ""), auth.phoneNumber))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 32)

            //  --- CODE FIELD ---
            CodeField(
                code: $smsCode,
                length: 6,
                status: status
            ) {
                verify()
            }
            .padding(.top, 8)

            // ERROR TEXT
            if let error = auth.authError {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Spacer()

            // CONTINUE BUTTON
            
            let isDisabled = (smsCode.count < 6 || isProcessing)
            
            Button {
                verify()
            } label: {
                HStack {
                    if isProcessing {
                        ProgressView()
                            .tint(Color.white)
                    } else {
                        Text("continue")
                            .font(.headline)
                    }
                }
                .foregroundColor(isDisabled ? Color.secondary : Color.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .padding(.horizontal, 40)
                .background(
                    isDisabled
                    ? Color.gray.opacity(0.3)
                    : Color.blue
                )
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .disabled(isDisabled)
            .padding(.horizontal, 80)
            .padding(.bottom, 32)
            .onTapGesture {
                hideKeyboard()
            }
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
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            } else {
                withAnimation(.easeInOut) {
                    status = .error
                }
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
}

#Preview {
    CodeVerificationView()
        .environmentObject(AuthViewModel())
}

