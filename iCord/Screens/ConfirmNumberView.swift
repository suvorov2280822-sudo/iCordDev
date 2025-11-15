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

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text(fullNumber)
                    .font(.title2.bold())

                Text("Is this number correct?")
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button("Edit") {
                        dismiss()
                        onEdit()
                    }
                    .frame(maxWidth: .infinity)

                    Button("Continue") {
                        onConfirm()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                
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
}
