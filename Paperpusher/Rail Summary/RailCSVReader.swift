//
//  RailCSVReader.swift
//  Paperpusher
//
//  Created by Joshua Kraft on 11/26/21.
//

import Cocoa

class RailCSVReader: NSObject {

    var path = String()
    var url: URL?
    
    var fileContents = String()
    
    var vesselVoyage = String()
    
    var containers = [RailCSVContainer]()
        
    func getFilePaths(path: String, url: URL?) {
        self.path = path
        self.url = url
        getFileData()
    }
        
    func getFileData() {
        
        let dest = DirectoryNames.copyDir + url!.lastPathComponent
        
        if FileManager.default.fileExists(atPath: dest) {
            do {
                try FileManager.default.removeItem(atPath: dest)
            } catch {
                NSAlert(error: error).runModal()
                print(error)
            }
        }
        
        do {
            try FileManager.default.copyItem(atPath: path, toPath: dest)
        } catch {
            NSAlert(error: error).runModal()
            print(error)
        }

        
        if FileManager.default.fileExists(atPath: dest) {
            fileContents = String(data: FileManager.default.contents(atPath: dest)!, encoding: .utf8)!
        }
        
    }
    
    func createRailContainers() {
        
        var separatedContents = fileContents.components(separatedBy: "\r\n")
        
        // Find the header row
        // Count the amount of rows to remove so there are only container lines left
        
        
        var headerRow = [String]()
        
        var removeCount = 0
        
        for line in separatedContents {
            
            if line.hasPrefix("CONTAINER PREFIX") {
                headerRow = line.components(separatedBy: ",")
                removeCount += 1
                break
            }
            
            if line.contains("VSL/VYG : ") {
                let firstSplit = line.components(separatedBy: "VSL/VYG : ")
                if let part = firstSplit.last {
                    let secondSplit = part.components(separatedBy: ",")
                    if let vslVoy = secondSplit.first {
                        vesselVoyage = vslVoy.replacingOccurrences(of: "/", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
                
            }
                        
            removeCount += 1
            
        }

        // Remove lines up to and including the header row
        
        separatedContents.removeFirst(removeCount)

        // Remove any blank lines
        
        for line in separatedContents {
            if line.isEmpty {
                if let index = separatedContents.firstIndex(of: line) {
                    separatedContents.remove(at: index)
                }
            }
        }
        
        
        // Create the containers
        
        for line in separatedContents {
            
            let lineParts = line.components(separatedBy: ",")
            
            let container = RailCSVContainer()
            
            if headerRow.contains("CONTAINER PREFIX") {
                let index = headerRow.firstIndex(of: "CONTAINER PREFIX")!
                container.containerName.append(lineParts[index].trimmingCharacters(in: .whitespaces))
            }
            
            if headerRow.contains("CONTAINER NUMBER") {
                let index = headerRow.firstIndex(of: "CONTAINER NUMBER")!
                container.containerName.append(lineParts[index].trimmingCharacters(in: .whitespaces))
            }
            
            if headerRow.contains("CONTAINER SUFFIX") {
                let index = headerRow.firstIndex(of: "CONTAINER SUFFIX")!
                container.containerName.append(lineParts[index].trimmingCharacters(in: .whitespaces))
            }
            
            if headerRow.contains("CT VESSEL BAY") {
                let index = headerRow.firstIndex(of: "CT VESSEL BAY")!
                container.stowagePos.append(lineParts[index].trimmingCharacters(in: .whitespaces))
            }

            if headerRow.contains("CT VESSEL CELL") {
                let index = headerRow.firstIndex(of: "CT VESSEL CELL")!
                container.stowagePos.append(lineParts[index].trimmingCharacters(in: .whitespaces))
            }
            
            if headerRow.contains("CT VESSEL TIER") {
                let index = headerRow.firstIndex(of: "CT VESSEL TIER")!
                container.stowagePos.append(lineParts[index].trimmingCharacters(in: .whitespaces))
            }


            if headerRow.contains("BLOCK DELIVERY") {
                let index = headerRow.firstIndex(of: "BLOCK DELIVERY")!
                container.railCode = lineParts[index].trimmingCharacters(in: .whitespaces)
            }
            
            containers.append(container)
            
        }
        
        
    }
    
    func reset() {
        fileContents = String()
        vesselVoyage = String()
        containers = [RailCSVContainer]()
        
        path = String()
        url = nil
    }
    
    
}
