//
//  Document.swift
//  IGCViewer
//
//  Created by Lukas Bischof on 26.04.17.
//  Copyright © 2017 Lukas Bischof. All rights reserved.
//

import Cocoa

class IGCDocument: NSDocument {
    
    var igcFile: IGCFile!
    var igcParsingError: IGCParsingError?

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return false
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
        windowController.window?.backgroundColor = NSColor.white
        windowController.window?.titlebarAppearsTransparent = true
        windowController.window?.isMovableByWindowBackground = true
        self.addWindowController(windowController)
    }

    override func data(ofType typeName: String) throws -> Data {
        Swift.print("\(#function)")
        
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        Swift.print("\(#function)")
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
        
        let parser = IGCParser(data: data)
        do {
            try parser.parse()
            
            self.igcFile = parser.outputFile
        } catch IGCParsingError.fileEncodingNotValid {
            Swift.print("File encoding not valid!!")
            
            igcParsingError = .fileEncodingNotValid
        } catch IGCParsingError.fileNotValid(let atLine, let why) {
            Swift.print("Can't parse file. Error at line \(atLine): \(why)")
            
            igcParsingError = IGCParsingError.fileNotValid(atLine: atLine, why: why)
        }
    }


}

