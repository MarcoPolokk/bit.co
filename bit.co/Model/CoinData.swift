//
//  CoinData.swift
//  bit.co
//
//  Created by Paweł Kozioł on 21/01/2020.
//  Copyright © 2020 Paweł Kozioł. All rights reserved.
//

import Foundation

//Make the struct conform to the Decodable protocol to use it to decode JSON.
struct CoinData: Decodable {
    
    //Last bitcoin price property in JSON data, given Double type data.
    let last: Double
}
