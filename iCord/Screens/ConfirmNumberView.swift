//
//  ConfirmNumberView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct ConfirmNumberView: View {
    let fullNumber: String
    let onEdit: () -> Void
    let onConfirm: () -> Void

    @EnvironmentObject var auth: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text(fullNumber)
                    .font(.title2.bold())

                Text(NSLocalizedString("confirm_title", comment: ""))
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button("edit") {
                        dismiss()
                        onEdit()
                    }
                    .frame(maxWidth: .infinity)

                    Button("continue") {
                        onConfirm()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if let errorMessage = auth.authError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.systemBackground))
            )
            .padding(32)
        }
    }
}

#Preview {
    ConfirmNumberView(
        fullNumber: "+1 (555) 123-4567",
        onEdit: {},
        onConfirm: {}
    )
    .environmentObject(AuthViewModel())
}

