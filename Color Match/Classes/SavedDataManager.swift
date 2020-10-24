//
//  SavedDataManager.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

class SavedDataManager {
    
    // MARK: - Enumerations
    
    /**
     * The saved file name to access
     */
    enum SavedFileName: String {
        
        case settings = "settings.plist"
        case colorlib = "colorlib.plist"
        
    }
    
    // MARK: - Static Properties
    
    /**
     * Class to manage the saved user settings
     */
    static let settings = SavedDataManager(for: .settings)
    
    /**
     * Class to manage the saved color library
     */
    static let colorlib = SavedDataManager(for: .colorlib)
    
    /**
     * The default values for each plist file
     */
    static let defaultValues: [SavedFileName : [String : Any]] = [
        .settings: [
            SettingsManager.UserSettingName.shouldUseWatercolor.rawValue : false
        ],
        
        .colorlib: [
            : // empty dictionary
        ]
    ]
    
    /**
     * The documents directory of the user's phone for this app
     */
    private static let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // MARK: - Properties
    
    /**
     * The current file being managed
     */
    private var savedFile: SavedFileName
    
    /**
     * The url to the current file being managed
     */
    private var savedFilePath: URL {
        SavedDataManager.docDir.appendingPathComponent(savedFile.rawValue, isDirectory: false)
    }
    
    /**
     * The dictionary object representation of this files contents
     */
    var savedData: [String : Any] {
        get {
            NSDictionary(contentsOf: savedFilePath) as? [String : Any] ?? Self.defaultValues[savedFile]!
        }
        set {
            let nsDict = NSDictionary(dictionary: newValue)
            do {
                try nsDict.write(to: savedFilePath)
            } catch {
                print("Error on saving \(newValue):", error)
            }
        }
    }
    
    // MARK: - Initializers
    
    /**
     * Creates a new class meant for managing a specific saved file
     */
    init(for file: SavedFileName) {
        savedFile = file
    }
    
    // MARK: Methods
    
    /**
     * Saves an item
     */
    func save(item: String, withValue value: Any) {
        savedData[item] = value
    }
    
    /**
     * Retrieves an item with a particular key
     */
    func retrieve(item: String) -> Any {
        savedData[item]!
    }
    
    /**
     * Retrieves **all** key-value pairs in this file. Returns a copy of the saved data as a dictionary
     */
    func retrieveAll() -> [String : Any] {
        savedData
    }
    
}
