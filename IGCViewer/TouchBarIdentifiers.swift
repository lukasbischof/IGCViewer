//
//  TouchBarIdentifiers.swift
//  IGCViewer
//
//  Created by Percy on 28.04.18.
//  Copyright © 2018 Lukas Bischof. All rights reserved.
//

import Foundation
import Cocoa

@available(OSX 10.12.2, *)
extension NSTouchBar.CustomizationIdentifier {
    static let igcMainBar = NSTouchBar.CustomizationIdentifier("de.pf-control.aseider.lukas.IGCViewer.main.touchbar")
}


@available(OSX 10.12.2, *)
extension NSTouchBarItem.Identifier {
    static let flightInfoLabel = NSTouchBarItem.Identifier("de.pf-control.aseider.lukas.IGCViewer.main.touchbar.info")
    static let flightScrubber = NSTouchBarItem.Identifier("de.pf-control.aseider.lukas.IGCViewer.main.touchbar.flight.scrubber")
}
