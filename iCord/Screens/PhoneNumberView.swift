//
//  PhoneNumberView.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PhoneNumberView: View {
    @EnvironmentObject var auth: AuthViewModel
    
    @State private var selectedCountry: Country = {
        let region = Locale.current.region?.identifier ?? ""
        if let match = countries.first(where: { $0.iso == region }) {
            return match
        } else if let first = countries.first {
            return first
        } else {
            return Country(name: "United States", iso: "US", code: "1", flag: "🇺🇸", mask: "(000) 000-0000")
        }
    }()
    
    @State private var phoneNumber: String = ""
    @State private var syncContacts: Bool = false
    @State private var showCountryPicker: Bool = false
    @State private var showConfirmSheet: Bool = false
    @State private var navigateToCode: Bool = false
    
    private var fullPhoneNumber: String {
        let trimmed = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        return  selectedCountry.code + trimmed
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
                
                Spacer().frame(height: 90)
                
                Text("phone_title")
                    .font(.largeTitle.bold())
                
                Text("phone_subtitle")
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
                        Text(selectedCountry.code)
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
                    
                    Divider().padding(.top, 4)
                }
                .padding(.horizontal, 24)
                
                Toggle("sync_contacts", isOn: $syncContacts)
                    .padding(.horizontal, 24)
                
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
                    
                    let isDisabled = !isContinueEnabled
                    
                    Text("continue")
                        .font(.headline)
                        .foregroundColor(isDisabled ? Color.secondary : Color.white)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 40)
                        .frame(maxWidth: .infinity)
                        .background(
                            isDisabled
                            ? Color.gray.opacity(0.3)
                            :  Color.blue
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!isContinueEnabled)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .padding(.top, 20)
                
                Spacer()
                
            }
            .padding(.top, 16)
            .onTapGesture {
                hideKeyboard()
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
                onEdit: { showConfirmSheet = false },
                onConfirm: {
                    auth.phoneNumber = fullPhoneNumber
                    auth.sendCode(fullPhoneNumber: fullPhoneNumber)
                }
            )
        }
        .onChange(of: auth.verificationID) { newValue in
            if newValue != nil {
                navigateToCode = true
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PhoneNumberView().environmentObject(AuthViewModel())
}
