//
//  CoinPriceTouchBar.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia. All rights reserved.
//

import Cocoa

class CoinPriceTouchBar: NSTouchBar {
    
    var prices: [Coin: String] = [:] {
        didSet {
            items.forEach { $0.price = prices[$0.coin] }
        }
    }
    
    private var items: [CoinPriceTouchBarItem] = supportedCoins.map { CoinPriceTouchBarItem(coin: $0) }
    
    override init() {
        super.init()
        templateItems = Set(items)
        defaultItemIdentifiers = [.fixedSpaceSmall, .flexibleSpace] + items.flatMap { [$0.identifier, .flexibleSpace] } + [.fixedSpaceSmall]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
