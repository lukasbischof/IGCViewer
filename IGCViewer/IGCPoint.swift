//
//  IGCpoint.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa

class IGCPoint: NSObject {
    private(set) var longitude: Float = 0.0
    private(set) var latitude: Float = 0.0
    
    init(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
        
        super.init()
    }
    
    override var description: String {
        get {
            return "<IGCPoint: latitude: \(latitude), longitude: \(longitude)>"
        }
    }
}
