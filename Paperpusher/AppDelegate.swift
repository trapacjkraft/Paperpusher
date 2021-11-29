//
//  AppDelegate.swift
//  Paperpusher
//
//  Created by Joshua Kraft on 11/12/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    
    let fm = FileManager.default
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        if !fm.fileExists(atPath: DirectoryNames.copyDir) {
            do {
                try fm.createDirectory(atPath: DirectoryNames.copyDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSAlert(error: error).runModal()
                print(error)
            }
        }
        
        if !fm.fileExists(atPath: DirectoryNames.railSummaryExportDir) {
            do {
                try fm.createDirectory(atPath: DirectoryNames.railSummaryExportDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSAlert(error: error).runModal()
                print(error)
            }
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

