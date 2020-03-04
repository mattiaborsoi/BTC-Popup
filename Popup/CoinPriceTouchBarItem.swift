//
//  CoinPriceTouchBarItem.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia Borsoi. All rights reserved.
//

import Cocoa

class CoinPriceTouchBarItem: NSTouchBarItem {

    let coin: Coin

    var price: String? {
        didSet {
            reloadText()
        }
    }

    private var textField: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        return textField
    }()

    override var view: NSView? {
        return textField
    }

    init(coin: Coin) {
        self.coin = coin
        super.init(identifier: NSTouchBarItem.Identifier(rawValue: self.coin.rawValue))
        textField.stringValue = identifier.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func reloadText() {
        guard let price = price else { return }
        let coinSymbol = coin.unicode()
        let string = "\(coinSymbol) \(price)"
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.foregroundColor, value: coin.color(), range: (string as NSString).range(of: coinSymbol))
        textField.attributedStringValue = attributedString
    }
}
