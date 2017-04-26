//
//  IGCParser.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa

enum IGCParsingError: Error {
    case fileNotValid(atLine: Int, why: String)
    case fileEncodingNotValid
}

class IGCParser: NSObject {
    private var data: Data
    private(set) var outputFile: IGCFile
    
    init(data: Data) {
        self.data = data
        self.outputFile = IGCFile()
        super.init()
    }
    
    func parse() throws -> Void {
        guard let str = String(data: data, encoding: String.Encoding.utf8) else {
            throw IGCParsingError.fileEncodingNotValid
        }
        
        let scanner = Scanner(string: str)
        let skipSet = CharacterSet.newlines
        let invertedSkipSet = skipSet.inverted
        
        scanner.charactersToBeSkipped = skipSet
        
        var lineNumb = 0
        while !scanner.isAtEnd {
            lineNumb += 1
            
            var scannedLine: NSString? = NSString()
            if !scanner.scanCharacters(from: invertedSkipSet, into: &scannedLine) {
                throw IGCParsingError.fileNotValid(atLine: lineNumb, why: "Invalid line")
            }
            
/*
 A - FR manufacturer and identification (always first)
 H - File header
 I - Fix extension list, of data added at end of each B
 record
 J - Extension list of data in each K record line
 C - Task/declaration (if used)
 L - Logbook/comments (if used)
 D - Differential GPS (if used)
 F - Initial Satellite Constellation
 B - Fix plus any extension data listed in I Record
 B - Fix plus any extension data listed in I Record
 E - Pilot Event (PEV)
 B - Fix plus any extension data listed in I Record
 K - Extension data as defined in J Record
 B - Fix plus any extension data listed in I Record
 B - Fix plus any extension data listed in I Record
 F - Constellation change
 B - Fix plus any extension data listed in I Record
 K - Extension data as defined in J Record
 B - Fix plus any extension data listed in I Record
 E - Pilot Event (PEV)
 B - Fix plus any extension data listed in I Record
 B - Fix plus any extension data listed in I Record
 B - Fix plus any extension data listed in I Record
 K - Extension data as defined in J Record
 L - Logbook/comments (if used)
 G - Security record (always last)
 */
            
            let line = String(scannedLine!)
            if line.characters.count < 2 {
                continue
            }
            
            let token = ("\(line[line.startIndex])")
            let recordValue = line[line.index(after: line.startIndex)..<line.endIndex]
            
            switch String(token).uppercased() {
            case "A":
                // FR manufacturer and identification
                try processARecord(recordValue)
                
            case "H":
                // File header
                try processHRecord(recordValue)
                
            case "B":
                // Fix plus any extension data listed in I Record
                try processBRecord(recordValue)
                
            default:
                //print("Unknown record")
                break
            }
        }
    }
    
    /* RECORD PROCESSING METHODS */
    
    private func processARecord(_ recordValue: String) throws {
        outputFile.manufacutrerCode = recordValue
    }
    
    private func processHRecord(_ recordValue: String) throws {
        let parts = recordValue.components(separatedBy: ":")
        
        if parts.count >= 2 {
            var couldSolve = true
            switch parts[0].uppercased() {
            case "FPLTPILOTINCHARGE":
                outputFile.header.pic = parts[1]
                
            case "FCM2CREW2":
                outputFile.header.secondPilot = parts[1]
                
            case "FGTYGLIDERTYPE":
                outputFile.header.gliderType = parts[1]
                
            case "FGIDGLIDERID":
                outputFile.header.gliderRegistration = parts[1]
                
            case "FDTM100GPSDATUM":
                outputFile.header.gpsDate = parts[1]
                
            case "FRFWFIRMWAREVERSION":
                outputFile.header.loggerFirmwareRevision = parts[1]
                
            case "FRHWHARDWAREVERSION":
                outputFile.header.loggerHardwareRevisionNumber = parts[1]
                
            case "FFTYFRTYPE":
                outputFile.header.loggerType = parts[1]
                
            case "FPRSPRESSALTSENSOR":
                outputFile.header.pressureSensorDesc = parts[1]
                
            case "FCIDCOMPETITIONID":
                outputFile.header.finNumber = parts[1]
                
            case "FCCLCOMPETITIONCLASS":
                outputFile.header.gliderClassification = parts[1]
                
            case "FGPS":
                outputFile.header.gpsModelDesc = parts[1]
                
            default:
                couldSolve = false
            }
            
            if couldSolve {
                return
            }
        }
        
        
        // All entries not separated by a colon and all entries which couldn't be interpreted above
        
        // GPS Data not in Xcsoar format
        if recordValue ~== "^FGPS.+" {
            let matches = recordValue ~> "^FGPS(.+)"
            if matches.count > 0 {
                outputFile.header.gpsModelDesc = matches[0]
            }
        }
        
        // UTC date this file was recorded
        if recordValue ~== "^FDTE\\d{6}" {
            let matches = recordValue ~> "FDTE(\\d{2})(\\d{2})(\\d{2})"
            
            if let day = Int(matches[0]), let month = Int(matches[1]), let year = Int(matches[2]) {
                print("\(String(describing: day)).\(String(describing: month)).\(String(describing: year))")
                
                var components = DateComponents()
                components.timeZone = TimeZone(abbreviation: "UTC")
                components.day = day
                components.month = month
                components.year = year + 2000 // The year is in a short style format i.e. 17 for 2017
                components.hour = 0
                components.minute = 0
                
                let date = Calendar.current.date(from: components)
                outputFile.header.recordingDate = date
            }
        }
        
        if recordValue ~== "^FFXA\\d{3}$" {
            if let fixAccuracy = Int((recordValue ~> "^FFXA(\\d{3})")[0]) {
                outputFile.header.fixAccuracy = fixAccuracy
            }
        }
    }
    
    private func processBRecord(_ recordValue: String) throws {
        if recordValue ~== "^(\\d{13})((?:N|S))\\d{8}((?:E|W))(A|V)(\\d{10})" {
            let matches = recordValue ~> "^(\\d{2})(\\d{2})(\\d{2})(\\d{2})(\\d{5})((?:N|S))(\\d{3})(\\d{5})((?:E|W))(A|V)(\\d{5})(\\d{5})"
            
            let hour = matches[0]
            let minute = matches[1]
            let second = matches[2]
            let latitudeDegreesStr = matches[3]
            let latitudeMinutesStr = matches[4]
            let northOrSouth = matches[5].uppercased()
            let longitudeDegreesStr = matches[6]
            let longitudeMinutesStr = matches[7]
            let westOrEast = matches[8].uppercased()
            let fixValidityStr = matches[9]
            let pressureAltitude = Float(matches[10])!
            let gnssAltitude = Float(matches[11])!
            
            var components = DateComponents()
            components.hour = Int(hour)
            components.minute = Int(minute)
            components.second = Int(second)
            components.timeZone = TimeZone(abbreviation: "UTC")
            let date = Calendar.current.date(from: components)
            
            var latitude = Float(latitudeDegreesStr)! + ((Float(latitudeMinutesStr)! / 1000) / 60.0)
            var longitude = Float(longitudeDegreesStr)! + ((Float(longitudeMinutesStr)! / 1000) / 60.0)
            
            latitude *= (northOrSouth == "S" ? -1 : 1)
            longitude *= (westOrEast == "W" ? -1 : 1)
            
            let waypoint = IGCWaypoint(latitude: latitude, longitude: longitude, date: date!, validityFix: fixValidityStr, pressureAltitude: pressureAltitude, gnssAltitude: gnssAltitude)
            
            outputFile.waypoints.append(waypoint)
        }
    }
}
