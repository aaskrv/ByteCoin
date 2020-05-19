//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Adilet on 5/12/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import Foundation

struct CoinModel {
    let currencyName: String
    let rate: Double
    
    var rateString : String {
        return String(format: "%.2f", rate)
    }
}
