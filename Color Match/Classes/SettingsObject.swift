//
//  SettingsManager.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

typealias Settings = SettingsObject

/// The instance of the settings object private to this class.
fileprivate let settings = Settings()

class SettingsObject {
    
    // MARK: - Properties
    
    let manager = SavedDataManager(for: .settings)
    
    // MARK: - Static Properties
    
    /**
     * These are all static accesses of the different settings properties.
     *
     * There is probably a much better way to do this, but this will have to do.
     */
    
    static var paintType: PaintType {
        set { settings.paintType = newValue }
        get { settings.paintType }
    }
    
    static var selectionWindowSize: Int {
        set { settings.selectionWindowSize = newValue }
        get { settings.selectionWindowSize }
    }
    
    static var useLight: Bool {
        set { settings.useLight = newValue }
        get { settings.useLight }
    }
    
    // MARK: - Stored Properties
    
    /*
     * These properties are stored on the user's device, they're permenant
     */
    
    /**
     * The type of paint being detected
     *
     * Default is `.acrylic`
     */
    private var paintType: PaintType = .acrlyic {
        didSet { saveSettings() }
    }
    
    /**
     * The width of the selection rectangle where all the colors are averaged
     */
    private var selectionWindowSize: Int = 8 {
        didSet { saveSettings() }
    }
    
    // MARK: - Dynamic Properties
    
    /*
     * These settings get reset to their defaults every time the app reloads
     */
    
    /**
     * Whether or not the user wants to use the flashlight
     *
     * Default is `false`
     */
    private var useLight = false {
        didSet { saveSettings() }
    }
    
    // MARK: - Initializers
    
    init() {
        do {
            let dict = try manager.retrieveDict()
            try decodeDict(dict)
        } catch {
            // the settings file does not yet exist, or it is invalid, so create a new one with default settings.
            print("Error reading valid settings file. Creating one with default settings.")
            self.saveSettings()
        }
    }
    
    // MARK: - Functions
    
    func decodeDict(_ dict: [String : Any]) throws {
        guard let paintRawValue = dict[SettingsJSONKeys.paintType.rawValue] as? String else {
            throw SettingsError.invalidJSON
        }
        
        guard let paintTypeEnumObj = PaintType(rawValue: paintRawValue) else {
            throw SettingsError.invalidJSON
        }
        
        guard let selectionSizeRawValue = dict[SettingsJSONKeys.selectionWindowSize.rawValue] as? Int else {
            throw SettingsError.invalidJSON
        }
        
        paintType = paintTypeEnumObj
        selectionWindowSize = selectionSizeRawValue
    }
    
    func encodeDict() -> [String : Any] {
        [
            SettingsJSONKeys.paintType.rawValue             : paintType.rawValue,
            SettingsJSONKeys.selectionWindowSize.rawValue   : selectionWindowSize
        ]
    }
    
    func saveSettings() {
        let dict = encodeDict()
        manager.saveDict(dict: dict)
    }
    
    // MARK: Class Functions
    
    class func save() {
        settings.saveSettings()
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
        case paintType              = "paint_type"
        case useFlash               = "use_flash"
        case selectionWindowSize    = "selection_window_size"
    }
    
    /**
     * A settings error
     */
    enum SettingsError: Error {
        
        /// Thrown when the saved json cannot be used to create a settings object
        case invalidJSON
    }
    
}
