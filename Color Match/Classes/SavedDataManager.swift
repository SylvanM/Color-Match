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
        
        case settings = "settings.json"
        case colorlib = "colorlib.json"
        
    }
    
    // MARK: - Static Properties
    
    /**
     * The documents directory of the user's phone for this app
     */
    private static let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // MARK: - Properties
    
    /**
     * The file being managed
     */
    var savedFile: SavedFileName
    
    /**
     * The url to the current file being managed
     */
    private var savedFileURL: URL {
        SavedDataManager.docDir.appendingPathComponent(savedFile.rawValue, isDirectory: false)
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
     * Retrieves the json object for the file. If the file does not exist, create an empty one.
     */
    func retrieveDict() throws -> [String : Any] {
        do {
            let data = try Data(contentsOf: savedFileURL)
            
            do {
                return try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String : Any]
            } catch {
                print("Could not recreate JSON object from data.")
                throw error
            }
        } catch {
            print("Could not find saved file: \(savedFileURL)")
            throw error
        }
    }
    
    /**
     * Saves the json object to the file
     */
    func saveDict(dict: [String : Any]) {
        print(dict)
        let json = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let data = Data(json)
        try! data.write(to: savedFileURL)
    }
    
}
