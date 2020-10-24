//
//  ColorReplicator.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation

typealias RGB = (red: Double, green: Double, blue: Double)

class ColorReplicator {
    
    // MARK: Enumerations
    
    /**
     * An acryllic paint color
     */
    enum Paint: String {
        
        // MARK: Acrylic Colors
        
        case red            = "red"
        case yellow         = "yellow"
        case yellowOchre    = "yellow_ochre"
        case lightBlue      = "light_blue"
        case darkBlue       = "dark_blue"
        case sepiaBrown     = "sepia_brown"
        case burntUmber     = "burnt_umber"
        
    }
    
    
    // MARK: Actions
    
    /**
     * Using the machine learning module, this calculates the pigment mixtures paint for a given RGB color
     *
     * - Parameters:
     *      - rgb: Tuple of the red, green, and blue values.
     *      - shouldCalculateWatercolor: flag indicating whether or not this function should calculate the mixture for water color instead of acrylic. Default is `false`
     *      - colors: `inout`dictionary for the color amounts
     */
    func calculateMixture(rgb: RGB, shouldCalculateWatercolor watercolor: Bool, colors: inout [Paint : Double]) {
        
    }
    
}
