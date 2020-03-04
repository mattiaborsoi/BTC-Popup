//
//  BinancePriceProvider.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia. All rights reserved.
//
import Foundation

struct BinancePriceProvider: CoinPriceProvider {
    
    func getPrice(of coin: Coin, in currency: FiatMoney, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://www.binance.com/api/v1/ticker/allPrices")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonArray = jsonObject as? [[String: String]],
                let coinJson = jsonArray.first(where: { $0["symbol"] == coin.rawValue + Coin.ETH.rawValue }),
                let coinPriceInETHString = coinJson["price"],
                let coinPriceInETH = Float(coinPriceInETHString) else {
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
