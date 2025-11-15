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
    
    func sendCode(fullPhoneNumber: String) async {
        authError = nil
        phoneNumber = fullPhoneNumber

        do {
            let verificationID = try await PhoneAuthProvider.provider()
                .verifyPhoneNumber(fullPhoneNumber, uiDelegate: nil)

            DispatchQueue.main.async {
                self.verificationID = verificationID
            }

        } catch {
            DispatchQueue.main.async {
                self.authError = error.localizedDescription
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
                    self?.authError = error.localizedDescription
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
    }
    
}
