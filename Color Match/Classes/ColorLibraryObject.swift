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
    typealias LibraryType = (acrylic: [String : SavedColor], watercolor: [String : SavedColor])
    
    /**
     * The file manager
     */
    var fileManager = SavedDataManager(for: .colorlib)
    
    /**
     * The colors in the user's library
     */
    var library: LibraryType = (acrylic: [:], watercolor: [:])
    
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
    public class func add(name: String, color: SavedColor, type: Settings.PaintType) {
        let libraryObject = ColorLibraryObject()
        
        switch type {
        case .acrlyic:
            libraryObject.library.acrylic[name] = color
        case .watercolor:
            libraryObject.library.watercolor[name] = color
        }

        libraryObject.saveLibrary()
    }
    
    /**
     * Gets all the saved colors
     */
    public class func getColors() -> LibraryType {
        let libraryObject = ColorLibraryObject()
        return libraryObject.library
    }
    
    private class func encodeDict(_ library: LibraryType) -> [String : Any] {
        
        /// Converts a `SavedColor` to a JSON-compatible thingy
        func colorToJSON(color: SavedColor) -> [String : Any] {
            [
                ColorLibJSONKey.rgb.rawValue        : [color.rgb.red, color.rgb.green, color.rgb.blue],
                ColorLibJSONKey.pigments.rawValue   : { 
                    var pigmentDict: [String : Any] = [:]
                    for key in color.pigments.keys {
                        pigmentDict[key.rawValue] = color.pigments[key]
                    }
                    return pigmentDict
                }()
            ]
        }
        
        var dict: [String : Any] = [:]
        var tempColorGroup: [String : Any] = [:]
        
        // save the acrylic colors
        for key in library.acrylic.keys {
            tempColorGroup[key] = colorToJSON(color: library.acrylic[key]!)
        }
        print(tempColorGroup)
        dict[Settings.PaintType.acrlyic.rawValue] = tempColorGroup
        tempColorGroup = [:]
        
        // save the watercolor colors
        for key in library.watercolor.keys {
            tempColorGroup[key] = colorToJSON(color: library.watercolor[key]!)
        }
        dict[Settings.PaintType.watercolor.rawValue] = tempColorGroup
        
        return dict
        
    }
    
    private class func decodeDict(_ dict: [String : Any]) -> LibraryType {
        
        if dict.isEmpty { return (acrylic: [:], watercolor: [:]) }
        
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
        
        var library: LibraryType = (acrylic: [:], watercolor: [:])
        
        var tempColorGroup: [String : Any] = dict[Settings.PaintType.acrlyic.rawValue] as! [String : Any]
        
        for key in tempColorGroup.keys {
            library.acrylic[key] = jsonToColor(json: tempColorGroup[key] as! [String : Any])
        }
        
        tempColorGroup = dict[Settings.PaintType.watercolor.rawValue] as! [String : Any]
        
        for key in tempColorGroup.keys {
            library.watercolor[key] = jsonToColor(json: tempColorGroup[key] as! [String : Any])
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
