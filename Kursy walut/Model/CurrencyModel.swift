//
//  CurrencyModel.swift
//  Kursy walut
//
//  Created by Michał Lubowicz on 30/06/2021.
//

import Foundation

struct NBPDataElement: Codable {
    let table, no, effectiveDate, currency, code: String?
    let rates: [Rate]
}

struct Rate: Codable {
    let currency, code, no, effectiveDate: String?
    let ask: Double?
    let bid: Double?
    var mid: Double?
}

typealias NBPData = [NBPDataElement]
