//
//  AppDelegate.swift
//  Popup
//
//  Created by Mattia Borsoi
//  Copyright © 2019 Mattia Borsoi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	let popover = NSPopover()
	var eventMonitor: EventMonitor?
    var currencyLabel = "£"
    var btcDisplayValue : Double = 0.0
   
    //
    let window: NSWindow
    private let btcCharacter = Coin.BTC.unicode()
    private let coinPriceTouchBarController = CoinPriceTouchBarController()
    override init() {
        window = NSWindow(contentViewController: coinPriceTouchBarController)
       // super.init()
    }
    //
    
    
    
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
        
		if let button = statusItem.button {
            statusItem.button?.title = currencyLabel + String(btcDisplayValue)
			button.action = #selector(AppDelegate.togglePopover(_:))
		}
        

		//let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "ViewControllerId") as! ViewController
		
		//popover.contentViewController = mainViewController
		
		eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
			if let popover = self?.popover {
				if popover.isShown {
					self?.closePopover(event)
				}
			}
		}
		eventMonitor?.start()
        
//        //DFRSystemModalShowsCloseBoxWhenFrontMost(true)
//        let customTouchBarItem = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(rawValue: btcCharacter))
//        let customTouchBarItemButton = NSButton(title: btcCharacter, target: self, action: #selector(AppDelegate.customTouchBarItemTapped))
//        customTouchBarItem.view = customTouchBarItemButton
//        NSTouchBarItem.addSystemTrayItem(customTouchBarItem)
//        DFRElementSetControlStripPresenceForIdentifier(customTouchBarItem.identifier.rawValue, true)
//
//        window.touchBar = coinPriceTouchBarController.touchBar
//        window.makeKeyAndOrderFront(nil)
        
	}

	func applicationWillTerminate(_ aNotification: Notification) {
	}

	@objc func togglePopover(_ sender: AnyObject?) {
		if popover.isShown {
			closePopover(sender)
		} else {
			showPopover(sender)
		}
	}
	
	func showPopover(_ sender: AnyObject?) {
		if let button = statusItem.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
			eventMonitor?.start()
		}
	}
	
	func closePopover(_ sender: AnyObject?) {
		popover.performClose(sender)
		eventMonitor?.stop()
	}
    
    @objc private func customTouchBarItemTapped() {
       // NSTouchBar.presentSystemModalFunctionBar(coinPriceTouchBarController.touchBar, systemTrayItemIdentifier: btcCharacter)
    }
    
}

