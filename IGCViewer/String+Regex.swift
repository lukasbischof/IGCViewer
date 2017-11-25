//
//  String+Regex.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Foundation

infix operator ~==
infix operator ~>
extension String {
    
    func testRegex(regex: String) -> Bool {
        if let regularExpression = try? NSRegularExpression(pattern: regex, options: []) {
            return regularExpression.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)).count > 0
        } else {
            print("Invalid Regex '\(regex)'")
            return false
        }
    }
    
    func pregMatch(pattern: String) -> [String] {
        var ret: [String] = []
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = regex.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count))
            
            for match in matches {
                for n in 1..<match.numberOfRanges {
                    let range = match.range(at: n)
                    ret.append(self.substring(with: self.index(self.startIndex, offsetBy: range.location)..<self.index(self.startIndex, offsetBy: range.location + range.length)))
                }
            }
            
            /*return matches.map {
                self.substring(with: self.index(self.startIndex, offsetBy: $0.range.location)..<self.index(self.startIndex, offsetBy: $0.range.location + $0.range.length))
            }*/
        }
        
        return ret
    }
    
    static func ~==(input: String, pattern: String) -> Bool {
        return input.testRegex(regex: pattern)
    }
    
    static func ~>(input: String, pattern: String) -> [String] {
        return input.pregMatch(pattern: pattern)
    }
}
