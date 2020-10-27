//
//  ColorLibrary.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

class ColorLibraryObject {
    
    // MARK: Properties
    
    typealias SavedColor = (rgb: RGB, pigments: [Double])
    
    /**
     * The file manager
     */
    var fileManager = SavedDataManager(for: .colorlib)
    
    /**
     * The colors in the user's library
     */
    var library: [String : SavedColor] = [:]
    
    // MARK: Initilalizers
    
    /**
     * Loads the color library from the saved json file
     */
    init() {
        
        let dict = fileManager.retrieveDict()
        library = ColorLibraryObject.decodeDict(dict)
        
    }
    
    // MARK: Methods
    
    private class func encodeDict(_ library: [String : SavedColor]) -> [String : Any] {
        
        /// Converts a `SavedColor` to a JSON-compatible thingy
        func colorToJSON(color: SavedColor) -> [String : Any] {
            [
                ColorLibJSONKey.rgb.rawValue        : [color.rgb.red, color.rgb.green, color.rgb.blue],
                ColorLibJSONKey.pigments.rawValue   : color.pigments
            ]
        }
        
        var dict: [String : Any] = [:]
        
        for key in library.keys {
            dict[key] = colorToJSON(color: library[key]!)
        }
        
        return dict
        
    }
    
    private class func decodeDict(_ dict: [String : Any]) -> [String : SavedColor] {
        
        /// Converts a JSON compatible dictionary to a `SavedColor`
        func jsonToColor(json: [String : Any]) -> SavedColor {
            let rgb = json[ColorLibJSONKey.rgb.rawValue] as! [Double]
            let pigmentArray = json[ColorLibJSONKey.pigments.rawValue] as! [Double]
            return (
                rgb         : (red: rgb[0], green: rgb[1], blue: rgb[2]),
                pigments    : pigmentArray
            )
        }
        
        var library: [String : SavedColor] = [:]
        
        for key in dict.keys {
            library[key] = jsonToColor(json: dict[key] as! [String : Any])
        }
        
        return library
    }
    
    func saveLibrary() {
        let dict = ColorLibraryObject.encodeDict(library)
        fileManager.saveDict(dict: dict)
    }
    
    // MARK: Enumerations
    
    /// A JSON key to encode this library
    enum ColorLibJSONKey: String {
        case rgb = "rgb"
        case pigments = "pigments"
    }

}
