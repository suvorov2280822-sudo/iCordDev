//
//  Country.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import Foundation


struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iso: String
    let code: String
    let flag: String
    let mask: String
}

