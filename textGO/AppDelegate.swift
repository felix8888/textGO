//
//  AppDelegate.swift
//  textGO
//
//  Created by 5km on 2019/1/18.
//  Copyright © 2019 5km. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let baiduAI = BaiduAI()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.image = NSImage(named: "statusIcon")
            button.window?.delegate = self
            button.window?.registerForDraggedTypes([NSPasteboard.PasteboardType("NSFilenamesPboardType"), NSPasteboard.PasteboardType.fileContents])
        }
        constructMenu()
        baiduAI.apiKey = "HGuY2oEGhPQAPC5VQrRIA40S"
        baiduAI.secretKey = "L3SUNohBY5vnAndfkp8IKYtPwv5Td908"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(withTitle: "截图识别", action: #selector(screenshotAndOCR), keyEquivalent: "s")
        menu.addItem(.separator())
        menu.addItem(withTitle: "偏好设置", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ",")
        menu.addItem(.separator())
        menu.addItem(withTitle: "退出", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        statusItem.menu = menu
    }
    
    @objc func screenshotAndOCR() {
//        let displayID = CGMainDisplayID()
//        let imageRef = CGDisplayCreateImage(displayID, rect: CGRect(x: 500, y: 500, width: 200, height: 200))
//        let bitmapRep = NSBitmapImageRep(cgImage: imageRef!)
//        let pngData = bitmapRep.representation(using: NSBitmapImageRep.FileType.png, properties: [:])!
////        let img = NSImage(data: pngData)!
//        let filePath = NSHomeDirectory() + "/Documents/test.png"
//        print(filePath)
//        try? pngData.write(to: URL(fileURLWithPath: filePath))
        
    }
    
}

extension AppDelegate: NSWindowDelegate, NSDraggingDestination {
    
    func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        if let button = statusItem.button {
            button.image = NSImage(named: "uploadIcon")
        }
        return .copy
    }
    
    func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if sender.isImageFile {
            let imgurl = sender.draggedFileURL!.absoluteURL
            let imgData = NSData(contentsOf: imgurl!)
            baiduAI.ocr(imgData!)
            return true
        }
        return false
    }
    
    func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }
    
    func draggingExited(_ sender: NSDraggingInfo?) {
        if let button = statusItem.button {
            button.image = NSImage(named: "statusIcon")
        }
    }
    
    func draggingEnded(_ sender: NSDraggingInfo) {
        if let button = statusItem.button {
            button.image = NSImage(named: "statusIcon")
        }
    }
    
}

extension AppDelegate: BaiduAIDelegate {
    func ocrError(type: BaiduAI.ErrorType, msg: String) {
        print(type)
        print(msg)
    }
    func ocrResult(text: String) {
        print(text)
    }
}
