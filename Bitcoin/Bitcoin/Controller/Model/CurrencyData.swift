//
//  CurrencyData.swift
//  Bitcoin
//
//  Created by SEREN on 21.03.2024.
//

import Foundation

struct CurrencyData: Codable {
    let asset_id_quote: String
    let rate: Double
    var rateString: String {return String (format: "%.1f", rate)}
}
