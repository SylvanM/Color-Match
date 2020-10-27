//
//  SettingsManager.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

class SettingsObject {
    
    // MARK: - Properties
    
    let manager = SavedDataManager(for: .settings)
    
    // MARK: Stored Properties
    
    /*
     * These properties are stored on the user's device, they're permenant
     */
    
    /**
     * The type of paint being detected
     *
     * Default is `.acrylic`
     */
    var paintType: PaintType = .acrlyic
    
    // MARK: Dynamic Properties
    
    /*
     * These settings get reset to their defaults every time the app reloads
     */
    
    /**
     * Whether or not the user wants to use the flashlight
     *
     * Default is `false`
     */
    var useLight = false
    
    // MARK: - Initializers
    
    init() {
        let dict = manager.retrieveDict()
        decodeDict(dict)
    }
    
    // MARK: Class Functions
    
    func decodeDict(_ dict: [String : Any]) {
        paintType = PaintType(rawValue: dict[SettingsJSONKeys.paintType.rawValue] as! String)!
    }
    
    func encodeDict() -> [String : Any] {
        [
            SettingsJSONKeys.paintType.rawValue : paintType.rawValue
        ]
    }
    
    // MARK: - Enumerations
    
    /**
     * The type of paint being detected
     */
    enum PaintType: String {
        
        /// Acrylic
        case acrlyic = "acrylic"
        
        /// Watercolor
        case watercolor = "watercolor"
        
    }
    
    /**
     * Keys used in the JSON encoding
     */
    private enum SettingsJSONKeys: String {
        case paintType  = "paint_type"
        case useFlash   = "use_flash"
    }
    
}
