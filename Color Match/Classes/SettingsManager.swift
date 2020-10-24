//
//  SettingsManager.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

class SettingsManager {
    
    // MARK: Enumerations
    
    /**
     * The name of a user setting
     */
    enum UserSettingName: String {
        
        case shouldUseWatercolor = "watercolor"
        
    }
    
    // MARK: Private
    
    /**
     * The file manager
     */
    let manager = SavedDataManager.settings
    
    // MARK: Methods
    
    /**
     * Sets a setting
     */
    func set(_ setting: UserSettingName, to value: Any) {
        manager.save(item: setting.rawValue, withValue: value)
    }
    
    /**
     * Gets a setting
     */
    func get(_ setting: UserSettingName) -> Any {
        manager.retrieve(item: setting.rawValue)
    }
    
}
