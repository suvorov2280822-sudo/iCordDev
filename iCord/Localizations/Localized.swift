//
//  Localized.swift
//  iCord
//
//  Created by Денис on 16/11/2025.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(_ argument: CVarArg) -> String {
        String(format: self.localized, argument)
    }
}
