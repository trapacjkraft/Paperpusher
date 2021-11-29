//
//  ViewController.swift
//  Paperpusher
//
//  Created by Joshua Kraft on 11/12/21.
//

import Cocoa

class ViewController: NSViewController, RailCodeListViewControllerDelegate {

    @IBOutlet var functionDropDown: NSPopUpButton!
    let options = ["Generate Rail Discharge Summary"]
    
    
    @IBOutlet var chooseFileButton: NSButton!
    @IBOutlet var clearFileButton: NSButton!
    
    @IBOutlet var fileNameLabel: NSTextField!
    
    @IBOutlet var performActionButton: NSButton!
    
    var filePath = String()
    var fileURL: URL?
    
    var hasFile = false {
        didSet {
            updateButtons()
        }
    }
    
    
    let railCodeVC: RailCodeListViewController = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil).instantiateController(withIdentifier: "RailCodeListViewController") as! RailCodeListViewController
    var railCSVReader = RailCSVReader()
    var railCSVSorter = RailCSVSorter()
    var railCSVExporter = RailCSVExporter()
    var allowedCodes = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        functionDropDown.removeAllItems()
        functionDropDown.addItems(withTitles: options)
        functionDropDown.selectItem(withTitle: "Generate Rail Discharge Summary")
        
        performActionButton.title = functionDropDown.titleOfSelectedItem ?? "Select Action..."
        
        railCodeVC.delegate = self

    }

    @IBAction func functionUpdated(_ sender: NSPopUpButton) {
        
        performActionButton.title = sender.titleOfSelectedItem ?? "Select Action..."
        
    }
    
    @IBAction func chooseFile(_ sender: Any) {
        
        let openMenu = NSOpenPanel()
        openMenu.canChooseFiles = true
        openMenu.canChooseDirectories = false
        openMenu.resolvesAliases = true
        openMenu.allowsMultipleSelection = false
        openMenu.allowedFileTypes = ["csv"]
        
        openMenu.title = "Choose a file (CSV format only)..."
        
        if (openMenu.runModal() == NSApplication.ModalResponse.OK) {
            
            fileURL = openMenu.url
            
            if fileURL != nil {
                filePath = fileURL!.path
                hasFile = true
            } else {
                hasFile = false
            }
            
        }
        
        if fileURL != nil {
            
            fileNameLabel.stringValue = fileURL!.lastPathComponent

        }

        
    }
 
    func updateButtons() {
        performActionButton.isEnabled = hasFile
        clearFileButton.isEnabled = hasFile
    }
    
    @IBAction func clearFile(_ sender: Any) {
        
        fileNameLabel.stringValue = ""
        hasFile = false
        
    }
    
    
    @IBAction func performAction(_ sender: Any) {
        
        if functionDropDown.titleOfSelectedItem == "Generate Rail Discharge Summary" {
            presentAsSheet(railCodeVC)
        }
        
    }
    

    func generateRailDischargeSummary(codes: [String]) {
        allowedCodes = codes
        railCSVReader.getFilePaths(path: filePath, url: fileURL)
        railCSVReader.createRailContainers()
        railCSVSorter.getContainers(containers: railCSVReader.containers)
        railCSVSorter.allowedCodes = allowedCodes
        railCSVSorter.sortContainers()
        railCSVExporter.getInfo(containerCounts: railCSVSorter.combinedContainersByBay, codeCounts: railCSVSorter.railCodeCounts, bayCounts: railCSVSorter.codeCountsByBay, codes: allowedCodes, vslvoy: railCSVReader.vesselVoyage)
        railCSVExporter.generateReport()
        
        if railCodeVC.isViewLoaded {
            railCodeVC.cancelAndClose(self)
        }
        
        railCSVReader.reset()
        railCSVSorter.reset()
        railCSVExporter.reset()
        
        clearFile(self)
        
    }
    
    
}

