//
//  CoinPriceProvider.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia Borsoi. All rights reserved.
//

protocol CoinPriceProvider {
    func getPrice(of: Coin, in currency: FiatMoney, completion: @escaping (String?) -> Void)
}
