//
//  SplashView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color(red: 0.92, green: 0.96, blue: 1.0) // временный голубой фон
                .ignoresSafeArea()

            Text("iCord")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.black)
        }
    }
}
