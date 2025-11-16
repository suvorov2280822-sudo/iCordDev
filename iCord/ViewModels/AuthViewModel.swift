//
//  AuthViewModel.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI
import Combine
import FirebaseAuth


class AuthViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var needsProfile: Bool = false
    
    @Published var verificationID: String? = nil
    @Published var phoneNumber: String = ""
    @Published var authError: String? = nil
    
    private var cancllables = Set<AnyCancellable>()
    private var authListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        authListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = (user != nil)
                self?.updateNeedsProfile(for: user)
            }
        }
    }
    
    deinit {
        if let handle = authListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    private func updateNeedsProfile(for user: User?) {
        guard let user else {
            needsProfile = false
            return
        }
        let key = "hasProfile_\(user.uid)"
        needsProfile = !UserDefaults.standard.bool(forKey: key)
    }
    
    private func friendlyError(_ error: Error) -> String {
        let text = error.localizedDescription.lowercased()

        // Device / Abuse protection
        if text.contains("blocked all requests") {
            return NSLocalizedString("error_blocked", comment: "")
        }
        if text.contains("unusual activity") {
            return NSLocalizedString("error_unusual_activity", comment: "")
        }

        // Incorrect verification code
        if text.contains("session expired") {
            return NSLocalizedString("error_code_expired", comment: "")
        }
        if text.contains("invalid verification code") {
            return NSLocalizedString("error_verification", comment: "")
        }

        // Phone number errors
        if text.contains("invalid phone number") {
            return NSLocalizedString("error_invalid_phone", comment: "")
        }
        if text.contains("missing phone number") {
            return NSLocalizedString("error_missing_phone", comment: "")
        }

        // Network
        if text.contains("network") {
            return NSLocalizedString("error_network", comment: "")
        }
        if text.contains("timed out") {
            return NSLocalizedString("error_timeout", comment: "")
        }

        // Quotas exceeded
        if text.contains("quota") {
            return NSLocalizedString("error_quota", comment: "")
        }

        // Internal / Unknown
        if text.contains("internal error") {
            return NSLocalizedString("error_internal", comment: "")
        }

        return NSLocalizedString("error_auth", comment: "")
    }
    
    func sendCode(fullPhoneNumber: String) {
        self.authError = nil
        
        PhoneAuthProvider.provider().verifyPhoneNumber(fullPhoneNumber, uiDelegate: nil) { verificationID, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.authError = self.friendlyError(error)
                }
                return
            }

            guard let verificationID = verificationID else {
                DispatchQueue.main.async {
                    self.authError = "Verification ID is empty"
                }
                return
            }

            DispatchQueue.main.async {
                self.verificationID = verificationID
            }
        }
    }

    func verifyCode(_ smsCode: String, completion: @escaping (Bool) -> Void) {
        authError = nil

        guard let verificationID = verificationID else {
            completion(false)
            return
        }

        let credential = PhoneAuthProvider.provider()
            .credential(withVerificationID: verificationID,
                        verificationCode: smsCode)

        Auth.auth().signIn(with: credential) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.authError = self?.friendlyError(error)
                    completion(false)
                    return
                }

                let user = result?.user
                self?.isLoggedIn = (user != nil)
                self?.updateNeedsProfile(for: user)
                completion(true)
            }
        }
    }
    
    func completeProfile(name: String) {
        guard let user = Auth.auth().currentUser else { return }
        
        let change = user.createProfileChangeRequest()
        change.displayName = name
        change.commitChanges { _ in }
        
        let key = "hasProfile_\(user.uid)"
        UserDefaults.standard.set(true, forKey: key)
        
        DispatchQueue.main.async {
            self.needsProfile = false
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        isLoggedIn = false
        verificationID = nil
        phoneNumber = ""
        needsProfile = false
        authError = nil
    }
    
}
