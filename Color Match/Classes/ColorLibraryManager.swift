//
//  ColorLibrary.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

class ColorLibraryManager {
    
    typealias SavedColorName = String
    
    // MARK: Properties
    
    /**
     * All the saved colors with their RGB and pigment mixtures
     */
    var colors: [String : (RGB, [ColorReplicator.Paint : Double])] {
        didSet {
            saveColors()
        }
    }
    
    /**
     * The class managing the color library file
     */
    let manager = SavedDataManager.colorlib
    
    // MARK: Initializers
    
    /**
     * Retrieves saved colors from the user's device and loads them
     */
    init() {
        let dataDict = manager.savedData
        
        for key in dataDict.keys {
            let item = dataDict[key] as! [String : Double]
            var colorMixture: [ColorReplicator.Paint : Double] = [:]
            
            for colorName in item.keys {
                if let color = ColorReplicator.Paint(rawValue: colorName) {
                    colorMixture[color] = item[colorName]!
                } else {
                    fatalError("Unknow color name")
                }
            }
        }
    }
    
    // MARK: Methods
    
    /**
     * Saves the colors.
     *
     * Automatically called when `colors` is altered.
     */
    func saveColors() {
        
    }
    
}
