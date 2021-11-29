//
//  SharedCode.swift
//  Paperpusher
//
//  Created by Joshua Kraft on 11/26/21.
//

import Cocoa

struct DirectoryNames {
    
    static let copyDir: String = NSHomeDirectory() + "/Documents/_copied-files/"
    static let railSummaryExportDir: String = NSHomeDirectory() + "/Documents/RailSummaries/"
    
}

extension String {
    
    var isNumeric: Bool { //Returns true if a string is numeric
        guard self.count > 0 else { return false }
        let numbers: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: numbers)
    }
    
    var isAlphabetic: Bool { //Returns true if a string is alphabetic
        guard self.count > 0 else { return false }
        let letters: Set<Character> = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        return Set(self.uppercased()).isSubset(of: letters)
    }
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String { //substring extension methods for splitting strings to and from indexes
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String { //subscript by range extension
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func indices(of occurrence: String) -> [Int] { //get all indexes of a given search string in a String
        var indices = [Int]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            let i = distance(from: startIndex,
                             to: range.lowerBound)
            indices.append(i)
            let offset = occurrence.distance(from: occurrence.startIndex,
                                             to: occurrence.endIndex) - 1
            guard let after = index(range.lowerBound,
                                    offsetBy: offset,
                                    limitedBy: endIndex) else {
                                        break
            }
            position = index(after: after)
        }
        return indices
    }
    
    func ranges(of searchString: String) -> [Range<String.Index>] { //get all ranges of a given search string in a String
        let _indices = indices(of: searchString)
        let count = searchString.count
        return _indices.map({ index(startIndex, offsetBy: $0)..<index(startIndex, offsetBy: $0+count) })
    }
    
    func withBoldText(boldPartsOfString: Array<NSString>, font: NSFont!, boldFont: NSFont!) -> NSAttributedString { //Bold all elements of an array that occur in an NSMutableAttributedString and return a new NSMutableAttributedString
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
        for i in 0 ..< boldPartsOfString.count {
            boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartsOfString[i] as String))
        }
        return boldString
    }
    
}
