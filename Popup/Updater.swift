//
//  Update.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia Borsoi. All rights reserved.
//

import Foundation

var btcDisplayValue = 0.0

class Updater {
    struct Response: Codable { // or Decodable
        let GBP: Double
    }
    func getValue()
    {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=GBP") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let res = try JSONDecoder().decode(Response.self, from: data)
                        btcDisplayValue = Double(res.GBP)
                    } catch let error {
                        print(error)
                    }
                }
                }.resume()
        }
        print(btcDisplayValue, "hereReturn")
        return
    }


}
