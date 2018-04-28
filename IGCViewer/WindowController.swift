//
//  WindowController.swift
//  IGCViewer
//
//  Created by Percy on 28.04.18.
//  Copyright © 2018 Lukas Bischof. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    @available(OSX 10.12.2, *)
    override func makeTouchBar() -> NSTouchBar? {
        guard let viewController = contentViewController as? ViewController else {
            return nil
        }
        return viewController.makeTouchBar()
    }
}
