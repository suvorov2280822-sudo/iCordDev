//
//  PhoneNumberView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

struct PhoneNumberView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var selectedCountry: Country = {
        let region = Locale.current.region?.identifier ?? ""
        return countries.first(where: { $0.iso == region }) ?? countries.first!
    }()
    
    
    @State private var phoneNumber: String = ""
    @State private var syncContacts: Bool = false
    
    @State private var showCountryPicker: Bool = false
    @State private var showConfirmSheet: Bool = false
    @State private var navigateToCode: Bool = false
    
    
    private var fullPhoneNumber: String {
        "+" + selectedCountry.code + phoneNumber.trimmingCharacters(in: .whitespaces)
    }
    
    private var isContinueEnabled: Bool {
        let digits = phoneNumber.filter { $0.isNumber }
        return digits.count >= 7
    }
    
    
    private func applyPhoneMask(_ text: String, mask: String) -> String {
        let digits = text.filter { $0.isNumber }
        var result = ""
        var index = digits.startIndex
        
        for ch in mask {
            if index == digits.endIndex { break }
            if ch == "0" {
                result.append(digits[index])
                index = digits.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Spacer()
                    .frame(height: 150)
                
                Text("Phone")
                    .font(.largeTitle.bold())
                
                Text("Please enter your mobile number.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(spacing: 8) {
                    Button {
                        showCountryPicker = true
                    } label: {
                        HStack {
                            Text(selectedCountry.flag)
                            Text(selectedCountry.name)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3))
                        )
                    }
                    
                    HStack(spacing: 12) {
                        Text("+\(selectedCountry.code)")
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3))
                            )
                        
                        TextField("", text: Binding(
                            get: {
                                applyPhoneMask(phoneNumber, mask: selectedCountry.mask)
                            },
                            set: { newValue in
                                phoneNumber = newValue.filter { $0.isNumber }
                            }
                        ))
                        .keyboardType(.numberPad)
                        .textContentType(.telephoneNumber)
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 4)
                    
                    Divider()
                        .padding(.top, 4)
                }
                .padding(.horizontal, 24)
                
                Toggle("Sync contacts", isOn: $syncContacts)
                    .padding(.horizontal,24)
                
                Spacer()
                    
                
                if let error = auth.authError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                
                Button {
                    showConfirmSheet = true
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!isContinueEnabled)
                .opacity(isContinueEnabled ? 1 : 0.4)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .navigationDestination(isPresented: $navigateToCode) {
                CodeVerificationView()
            }
        }
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerView(selectedCountry: $selectedCountry)
        }
        .sheet(isPresented: $showConfirmSheet) {
            ConfirmNumberView(
                fullNumber: fullPhoneNumber,
                onEdit: { showConfirmSheet = false},
                onConfirm: {
                    showConfirmSheet = false
                    Task {
                        await auth.sendCode(fullPhoneNumber: fullPhoneNumber)
                    }
                }
            )
        }
        .onChange(of: auth.verificationID) {newValue in
            if newValue != nil {
                
                navigateToCode = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PhoneNumberView()
        .environmentObject(AuthViewModel())
}
