//
//  RailCodeListViewController.swift
//  Paperpusher
//
//  Created by Joshua Kraft on 11/27/21.
//

import Cocoa

protocol RailCodeListViewControllerDelegate: class {
    func generateRailDischargeSummary(codes: [String])
}

class RailCodeListViewController: NSViewController {

    @IBOutlet var railCodeTextView: NSTextView!
    
    @IBOutlet var generateButton: NSButton!
    
    var allowedCodes = [String]()
    
    weak var delegate: RailCodeListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func passCodes(_ sender: Any) {
        
        if let stringValue = railCodeTextView.textContainer?.textView?.string {
            if !stringValue.isEmpty {
                
                if stringValue.contains(",") {
                    
                    let parts = stringValue.components(separatedBy: ",")
                    
                    for part in parts {
                        
                        if !part.isEmpty {
                            allowedCodes.append(part.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                        }
                    }
                    
                } else if stringValue.contains(" ") {
                    
                    let parts = stringValue.components(separatedBy: " ")
                    
                    for part in parts {
                        
                        if !part.isEmpty {
                            allowedCodes.append(part.trimmingCharacters(in: .whitespacesAndNewlines).uppercased())
                        }
                    }
                    
                } else if stringValue.count == 3 {
                    allowedCodes.append(stringValue)
                }
                
            }
        }
        
        delegate?.generateRailDischargeSummary(codes: allowedCodes)
    }
    
    
    @IBAction func cancelAndClose(_ sender: Any) {
        allowedCodes.removeAll()
        railCodeTextView.textContainer?.textView?.string.removeAll()
        dismiss(self)
    }
    
    
}
