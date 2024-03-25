//
//  CoinManager.swift
//  Bitcoin
//
//  Created by SEREN on 19.03.2024.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCurrency (_ coinManager : CoinManager, currency : CurrencyData)
    func didFailWithError (error: Error)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "?apikey=BD1A1588-E46C-4500-9447-44DE911778D1#"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice (for currency: String) {
        let urlString = "\(baseURL)\(currency)\(apiKey)"
        performRequest (urlString: urlString)
    }
    
    func performRequest (urlString: String) {
        if let url = URL (string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coinData = self.parseJSON(currencyData: safeData){
                        self.delegate?.didUpdateCurrency(self, currency: coinData)}
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(currencyData: Data) -> CurrencyData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: currencyData)
            let asset_id_quote = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coinData = CurrencyData (asset_id_quote: asset_id_quote, rate: rate)
            return coinData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }

}
