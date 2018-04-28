//
//  DateUtilities.swift
//  IGCViewer
//
//  Created by Percy on 29.04.18.
//  Copyright © 2018 Lukas Bischof. All rights reserved.
//

import Foundation

func formatDate(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    formatter.locale = Calendar.current.locale
    
    return formatter.string(from: date)
}

func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    formatter.locale = Calendar.current.locale
    
    return formatter.string(from: date)
}

func formatTime(date: Date, renderSeconds: Bool) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    formatter.dateStyle = .none
    formatter.timeStyle = renderSeconds ? .medium : .short
    formatter.locale = Calendar.current.locale
    
    return formatter.string(from: date)
}
