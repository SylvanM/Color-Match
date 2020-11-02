//
//  ColorLibrary.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

class ColorLibraryObject {
    
    // MARK: Properties
    
    typealias SavedColor = (rgb: RGB, pigments: [ColorReplicator.Paint : Double])
    
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
        
        do {
            let dict = try fileManager.retrieveDict()
            library = ColorLibraryObject.decodeDict(dict)
        } catch {
            print("Error reading color library file. Creating empty library now.")
            self.saveLibrary()
        }
        
    }
    
    // MARK: Class Functions
    
    /**
     * Adds and saves a new color to the library
     */
    public class func add(name: String, color: SavedColor) {
        let libraryObject = ColorLibraryObject()
        libraryObject.library[name] = color
        libraryObject.saveLibrary()
    }
    
    /**
     * Gets all the saved colors
     */
    public class func getColors() -> [String : SavedColor] {
        let libraryObject = ColorLibraryObject()
        return libraryObject.library
    }
    
    private class func encodeDict(_ library: [String : SavedColor]) -> [String : Any] {
        
        /// Converts a `SavedColor` to a JSON-compatible thingy
        func colorToJSON(color: SavedColor) -> [String : Any] {
            [
                ColorLibJSONKey.rgb.rawValue        : [color.rgb.red, color.rgb.green, color.rgb.blue],
                ColorLibJSONKey.pigments.rawValue   : color.pigments.map({ (element) -> ((key: String, value: Double)) in
                    (key: element.key.rawValue, value: element.value)
                })
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
            let pigmentArray = json[ColorLibJSONKey.pigments.rawValue] as! [String : Double]
            return (
                rgb         : (red: rgb[0], green: rgb[1], blue: rgb[2]),
                pigments    : {
                    var dict: [ColorReplicator.Paint : Double] = [:]
                    for (pigment, val) in pigmentArray {
                        dict[ColorReplicator.Paint(rawValue: pigment)!] = val
                    }
                    return dict
                }()
            )
        }
        
        var library: [String : SavedColor] = [:]
        
        for key in dict.keys {
            library[key] = jsonToColor(json: dict[key] as! [String : Any])
        }
        
        return library
    }
    
    
    
    // MARK: Functions
    
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
