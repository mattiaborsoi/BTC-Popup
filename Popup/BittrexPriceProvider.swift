//
//  BittrexPriceProvider.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia. All rights reserved.
//
import Foundation

struct BittrexPriceProvider: CoinPriceProvider {
    
    func getPrice(of coin: Coin, in currency: FiatMoney, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://bittrex.com/api/v1.1/public/getmarketsummary?market=eth-\(coin.rawValue.lowercased())")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonObject as? [String: Any],
                let dataJson = json["result"] as? [[String: Any]],
                let dataFirst = dataJson.first,
                let coinPriceInETH = dataFirst["Last"] as? Float else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
            }
            CoinbasePriceProvider().getPrice(of: .ETH, in: currency) { ethPriceString in
                guard let ethPriceString = ethPriceString,
                    let ethPrice = Float(ethPriceString) else {
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                        return
                }
                let price = coinPriceInETH * ethPrice
                DispatchQueue.main.async {
                    completion(String(price))
                }
            }
        }.resume()
    }
}

