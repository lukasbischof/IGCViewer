//
//  ViewController+TouchBar.swift
//  IGCViewer
//
//  Created by Percy on 28.04.18.
//  Copyright © 2018 Lukas Bischof. All rights reserved.
//

import Cocoa

@available(macOS 10.12.2, *)
extension ViewController : NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .igcMainBar
        touchBar.defaultItemIdentifiers = [.flightInfoLabel, .flightScrubber]
        touchBar.customizationAllowedItemIdentifiers = [.flightInfoLabel, .flightScrubber]
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case .flightInfoLabel:
            return makeFlightInfoLabel(identifier: identifier)
        case .flightScrubber:
            return makeFlightScrubber(identifier: identifier)
        default:
            return nil
        }
    }
    
    private func makeFlightScrubber(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        let touchBarItem = NSSliderTouchBarItem(identifier: identifier)
        touchBarItem.slider.minValue = self.slider.minValue
        touchBarItem.slider.maxValue = self.slider.maxValue
        touchBarItem.action = #selector(sliderValueChanged(_:))
        touchBarItem.customizationLabel = "Flight Scrubber"
        
        return touchBarItem
    }
    
    private func makeFlightInfoLabel(identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem {
        let touchBarItem = NSCustomTouchBarItem(identifier: identifier)
        let textField = NSTextField(string: self.document.igcFile.header.touchBarLabel())
        textField.textColor = NSColor.disabledControlTextColor
        touchBarItem.view = textField
        touchBarItem.customizationLabel = "Flight Info"
        return touchBarItem
    }
}
