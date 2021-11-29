//
//  RailCSVSorter.swift
//  Paperpusher
//
//  Created by Joshua Kraft on 11/27/21.
//

import Cocoa

class RailCSVSorter: NSObject {

    var containers = [RailCSVContainer]()
    
    var bays = [String]()
    var railCodes = [String]()
    
    var containersByBay = [String: [RailCSVContainer]]()
    
    var combinedContainersByBay = [String: [RailCSVContainer]]()
    var railCodeCounts = [String: Int]()
    var codeCountsByBay = [String: [String: Int]]()
    
    var allowedCodes = [String]()
    
    func getContainers(containers: [RailCSVContainer]) {
        self.containers = containers
    }
    
    func sortContainers() {
        
        for container in containers {
            
            // Create a list of the rail codes
            
            if !railCodes.contains(container.railCode) {
                // If the rail code is allowed
                if allowedCodes.contains(container.railCode) {
                    if !container.railCode.isEmpty {
                        // Add the code if it does not exist
                        railCodes.append(container.railCode)
                        // Create a count entry if it does not exist
                        railCodeCounts.updateValue(0, forKey: container.railCode)
                    }
                }
            }
            
            // Count the amount of times each rail code exists
            // If this entry exists
            if let _ = railCodeCounts[container.railCode] {
                railCodeCounts[container.railCode]! += 1 // Increment the count for this code
            }
            
            
            
            // Sort the containers by bay
            // Find the 2-digit bay
            let bay = container.stowagePos.substring(toIndex: 2)
            
            if !bays.contains(bay) {
                
                // Add the bay to the list if it doesn't exist
                bays.append(bay)
                // Create an entry in the sorted list
                containersByBay.updateValue([RailCSVContainer](), forKey: bay)
            }
            
            // if the entry for this bay exists
            
            if let _ = containersByBay[bay] {
                
                // if the entry does not contain this container add it
                if !containersByBay[bay]!.contains(container) {
                    if allowedCodes.contains(container.railCode) {
                        containersByBay[bay]!.append(container)
                    }
                }
            }
            
            for key in containersByBay.keys {
                
                if let bay = Int(key) {
                    
                    if bay.isMultiple(of: 2) {
                        let baysToCombine = [String(bay - 1), String(bay), String(bay + 1)]
                        var combinedContainers = [RailCSVContainer]()
                        
                        for var eachBay in baysToCombine {
                            
                            if eachBay.count == 1 {
                                eachBay.insert("0", at: String.Index(utf16Offset: 0, in: eachBay))
                            }
                            
                            if let conts = containersByBay[eachBay] {
                                for container in conts {
                                    combinedContainers.append(container)
                                }
                            }
                        }
                        
                        combinedContainersByBay.updateValue(combinedContainers, forKey: key)
                    }
                }
            }
        }
        
        for key in combinedContainersByBay.keys {
            
            // Create an empty entry for the bay
            
            codeCountsByBay.updateValue([String: Int](), forKey: key)
            
            for code in allowedCodes {
                
                if let _ = codeCountsByBay[key] {
                    
                    // Create a 0-count entry for each code
                    codeCountsByBay[key]!.updateValue(0, forKey: code)
                }
                
            }
            
            if let containers = combinedContainersByBay[key] {
                
                for container in containers {
                    
                    if let _ = codeCountsByBay[key]![container.railCode] {
                        codeCountsByBay[key]![container.railCode]! += 1
                    }
                    
                }
                
            }
            
        }
        
        
        
    }
    
    func reset() {
        
        containers = [RailCSVContainer]()
        
        bays = [String]()
        railCodes = [String]()
        
        containersByBay = [String: [RailCSVContainer]]()
        
        combinedContainersByBay = [String: [RailCSVContainer]]()
        railCodeCounts = [String: Int]()
        codeCountsByBay = [String: [String: Int]]()
        
        allowedCodes = [String]()
        
    }
    
}
