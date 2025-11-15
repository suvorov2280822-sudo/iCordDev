//
//  HomeView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("You are logged in")
                    .font(.title.bold())

                if !auth.phoneNumber.isEmpty {
                    Text(auth.phoneNumber)
                        .foregroundColor(.secondary)
                }

                Button("Sign out") {
                    auth.signOut()
                }
                .buttonStyle(.bordered)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .navigationTitle("iCord")
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}
