//
//  CodeField.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import SwiftUI

enum CodeFieldStatus {
    case normal
    case error
    case success
}





struct CodeField: View {
    @Binding var code: String
    let length: Int
    let status: CodeFieldStatus
    var onCommit: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    
    
    
    var body: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .focused($isFocused)
                .onChange(of: code) {newValue in
                    if newValue.count > length {
                        code = String(newValue.prefix(length))
                    }
                    if newValue.count == length {
                        onCommit?()
                    }
                }
                .opacity(0.01)
            
            
            HStack(spacing: 12) {
                ForEach(0..<length, id: \.self) { index in
                    let character = character(at: index)
                    
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(borderColor(for: index), lineWidth: 2)
                        .frame(width: 44, height: 52)
                        .overlay(
                            Text(character.map(String.init) ?? "")
                                .font(.title2)
                        )
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isFocused = true
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isFocused = true
            }
        }
    }
    
    private func character(at index: Int) -> Character? {
        guard index < code.count else { return nil }
        let strIndex = code.index(code.startIndex, offsetBy: index)
        return code[strIndex]
    }
    
    private func borderColor(for index: Int) -> Color {
        switch status {
        case .normal:
            if index == code.count {
                return .black
            } else if index < code.count {
                return .black
            } else {
                return .gray.opacity(0.4)
            }
        case .error:
            return .red
            
        case .success:
            return .green
        }
    }
}

