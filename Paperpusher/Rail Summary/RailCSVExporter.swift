//
//  RailCSVExporter.swift
//  Paperpusher
//
//  Created by Joshua Kraft on 11/27/21.
//

import Cocoa

class RailCSVExporter: NSObject {

    var combinedContainersByBay = [String: [RailCSVContainer]]()
    var railCodeCounts = [String: Int]()
    var codeCountsByBay = [String: [String: Int]]()
    
    var allowedCodes = [String]()
    
    var vesselVoyage = String()

    func getInfo(containerCounts: [String: [RailCSVContainer]], codeCounts: [String: Int], bayCounts: [String: [String: Int]], codes: [String], vslvoy: String) {
        
        combinedContainersByBay = containerCounts
        railCodeCounts = codeCounts
        codeCountsByBay = bayCounts
        allowedCodes = codes
        vesselVoyage = vslvoy
        
    }
    
    func generateReport() {
        
        var report = String()
        
        report.append("Bay,")
        report.append(allowedCodes.joined(separator: ","))
        report.append(",Grand Total\n")
        
        
        for key in codeCountsByBay.keys.sorted(by: <) {
            
            report.append(key + ",")
            
            for code in allowedCodes {
                
                if let bayCounts = codeCountsByBay[key] {
                    if let codeCount = bayCounts[code] {
                        report.append(String(codeCount) + ",")
                    }
                }
                
            }
            
            if let bayTotal = combinedContainersByBay[key] {
                report.append(String(bayTotal.count) + "\n")
            }
            
        }
        
        report.append("Total,")
        
        var sum = 0
        
        for code in allowedCodes {
            
            if let count = railCodeCounts[code] {
                
                sum += count
                report.append(String(count) + ",")
                
            }
            
        }
        
        report.append(String(sum) + "\n")
        
        
        let filename = "Rail Discharge Breakdown for " + vesselVoyage + ".csv"
        
        if FileManager.default.fileExists(atPath: DirectoryNames.railSummaryExportDir) {
            
            let destination = DirectoryNames.railSummaryExportDir + filename
            
            if FileManager.default.fileExists(atPath: destination) {
                do {
                    try FileManager.default.removeItem(atPath: destination)
                } catch {
                    NSAlert(error: error).runModal()
                    print(error)
                }
            }
            
            do {
                try report.write(toFile: destination, atomically: true, encoding: .utf8)
            } catch {
                NSAlert(error: error).runModal()
                print(error)
            }
            
            if !NSWorkspace.shared.openFile(destination, withApplication: "Microsoft Excel") {
                NSWorkspace.shared.openFile(destination, withApplication: "Numbers")
            }
        }
        
        
    }
    
    func reset() {
        
        combinedContainersByBay = [String: [RailCSVContainer]]()
        railCodeCounts = [String: Int]()
        codeCountsByBay = [String: [String: Int]]()
        
        allowedCodes = [String]()
        
        vesselVoyage = String()

    }
    
}
