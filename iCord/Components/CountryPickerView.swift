//
//  CountryPickerView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct CountryPickerView: View {
    @Binding var selectedCountry: Country
    @Environment(\.dismiss) private var dismiss
    
    
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(countries) { country in
                    Button {
                        selectedCountry = country
                        dismiss()
                    } label: {
                        HStack {
                            Text(country.flag)
                            Text(country.name)
                            Spacer()
                            Text(country.code)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Country")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

