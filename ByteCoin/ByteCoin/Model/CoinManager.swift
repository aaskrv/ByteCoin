//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Adilet on 5/12/20.
//  Copyright © 2020 Adilet. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didFailWithError(_ error : Error)
    func didUpdateCurrency(_ coinManager: CoinManager, currency: CoinModel)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "AAEFD7DF-BA49-4F51-AE40-76D2EE8C34CE"
    
    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let currencyString = "\(baseURL)/\(currency)/?apikey=\(apiKey)"
        performRequest(using: currencyString)
    }
    
    func performRequest(using selectedCurrency : String) {
        if let url = URL(string: selectedCurrency) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                
                if let safeData = data {
                    if let currency = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, currency: currency)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ currencyData : Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: currencyData)
            print(decodedData)
            let name = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let currentCurrency = CoinModel(currencyName: name, rate: rate)
            return currentCurrency
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
        
    }
}
