//
//  Update.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia. All rights reserved.
//
import Foundation

struct CoinbasePriceProvider: CoinPriceProvider {
    
    func getPrice(of coin: Coin, in currency: FiatMoney, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.coinbase.com/v2/prices/\(coin)-\(currency)/spot")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonObject as? [String: Any], let dataJson = json["data"] as? [String: Any],
                let price = dataJson["amount"] as? String else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
            }
            DispatchQueue.main.async {
                completion(price)
            }
        }.resume()
    }
}
