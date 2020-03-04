//
//  CoinPriceTouchBarController.swift
//  Popup
//
//  Created by Mattia Borsoi on 04/09/2019.
//  Copyright © 2019 Mattia Borsoi. All rights reserved.
//

import Cocoa

class CoinPriceTouchBarController: NSViewController {

    private let priceRefreshInterval: TimeInterval = 15
    private let coinPriceTouchBar = CoinPriceTouchBar()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        self.view = NSView()
    }

    override func makeTouchBar() -> NSTouchBar? {
        return coinPriceTouchBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for coin in supportedCoins {
            getPrice(of: coin)
        }
    }

    private func getPrice(of coin: Coin) {
        coin.priceProvider().getPrice(of: coin, in: currency) { [weak self] price in
            guard let sself = self else { return }
            sself.coinPriceTouchBar.prices[coin] = price
            Timer.scheduledTimer(withTimeInterval: sself.priceRefreshInterval, repeats: false) { [weak sself] _ in
                sself?.getPrice(of: coin)
            }
        }
    }


    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    @IBAction func closeButtonAction(_ sender: NSButton) {
        NSApp.terminate(self)
    }
}
