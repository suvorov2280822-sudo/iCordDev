//
//  CountryData.swift
//  iCord
//
//  Created by Денис on 15/11/2025.
//

import Foundation

// Пока небольшой список, потом можно расширить.
let countries: [Country] = [
    Country(name: "Netherlands", iso: "NL", code: "31",  flag: "🇳🇱", mask: "00 000 00 00"),
    Country(name: "Ukraine",     iso: "UA", code: "380", flag: "🇺🇦", mask: "00 000 00 00"),
    Country(name: "Germany",     iso: "DE", code: "49",  flag: "🇩🇪", mask: "000 000000"),
    Country(name: "Poland",      iso: "PL", code: "48",  flag: "🇵🇱", mask: "000 000 000"),
    Country(name: "France",      iso: "FR", code: "33",  flag: "🇫🇷", mask: "0 00 00 00 00"),
    Country(name: "United States", iso: "US", code: "1", flag: "🇺🇸", mask: "(000) 000-0000"),
]
