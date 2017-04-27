//
//  TimeInterval+formatting.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 27.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Foundation

extension TimeInterval {
    func getFormattedTime() -> String {
        let minutes = Int(fmodf(floor(Float(self / 60.0)), 60.0))
        let seconds = Int(fmodf(Float(self), 60.0))
        let hours = Int(fmodf(floor(Float(self / 3_600)), 3_600))
        
        return "\(hours):\(minutes):\(seconds)"
    }
}
