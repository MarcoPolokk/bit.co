//
//  CoinManager.swift
//  bit.co
//
//  Created by Paweł Kozioł on 21/01/2020.
//  Copyright © 2020 Paweł Kozioł. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "7AF9BA7F-A2D4-4AE2-8417-A04A11C9D9E2"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        //Use String concatenation to add all the parts needed to generate working https request.
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //Use optional binding to unwrap the URL that's created from the urlString.
        if let url = URL(string: urlString) {
            
            //Create a new URLSession object with default configuration.
            let session = URLSession(configuration: .default)
            
            //Create a new data task for the URLSession.
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let bitCoinData = self.parseJSON(safeData) {
                        
                        //Round the price down to 2 decimal places.
                        let priceString = String(format: "%.2f", bitCoinData)
                        
                        //Call the delegate method in the delegate (ViewController) and pass along the necessary data.
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        //Create a JSONDecoder
        let decoder = JSONDecoder()
        
        do {
            
            //Try to decode the data using the CoinData Structure.
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            //Get the last property from the decoded data.
            let lastPrice = decodedData.rate
            return lastPrice
            
        } catch {
            
            //Catch and print any errors.
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
