//
//  ColorReplicator.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/23/20.
//

import Foundation
import CoreML

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
        case white          = "white"
        
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
        
        let configuration = MLModelConfiguration()
        
        do {
            
            let models: [Paint : MLModel] = [
                .red            : try Acrylic_Red(configuration: configuration).model,
                .yellow         : try Acrylic_Yellow(configuration: configuration).model,
                .yellowOchre    : try Acrylic_Yellow_Ochre(configuration: configuration).model,
                .lightBlue      : try Acrylic_Light_Blue(configuration: configuration).model,
                .darkBlue       : try Acrylic_Dark_Blue(configuration: configuration).model,
                .sepiaBrown     : try Acrylic_Sepia_Brown(configuration: configuration).model,
                .burntUmber     : try Acrylic_Burnt_Umber(configuration: configuration).model,
                .white          : try Acrylic_White(configuration: configuration).model
            ]
            
            let inputs: [Paint : MLFeatureProvider] = [
                .red         : Acrylic_RedInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
                .yellow      : Acrylic_YellowInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
                .yellowOchre : Acrylic_Yellow_OchreInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
                .lightBlue   : Acrylic_Light_BlueInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
                .darkBlue    : Acrylic_Dark_BlueInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
                .sepiaBrown  : Acrylic_Sepia_BrownInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
                .burntUmber  : Acrylic_Burnt_UmberInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
                .white       : Acrylic_WhiteInput(Red: rgb.red, Green: rgb.green, Blue: rgb.blue),
            ]
            
            colors = [
                .red            : Acrylic_RedOutput(features:           try models[.red]!           .prediction(from: inputs[.red]          as! Acrylic_RedInput)).Red_1,
                .yellow         : Acrylic_YellowOutput(features:        try models[.yellow]!        .prediction(from: inputs[.yellow]       as! Acrylic_YellowInput)).Yellow,
                .yellowOchre    : Acrylic_Yellow_OchreOutput(features:  try models[.yellowOchre]!   .prediction(from: inputs[.yellowOchre]  as! Acrylic_Yellow_OchreInput)).Yellow_Ochre,
                .lightBlue      : Acrylic_Light_BlueOutput(features:    try models[.lightBlue]!     .prediction(from: inputs[.lightBlue]    as! Acrylic_Light_BlueInput)).Light_Blue,
                .darkBlue       : Acrylic_Dark_BlueOutput(features:     try models[.darkBlue]!      .prediction(from: inputs[.darkBlue]     as! Acrylic_Dark_BlueInput)).Dark_Blue,
                .sepiaBrown     : Acrylic_Sepia_BrownOutput(features:   try models[.sepiaBrown]!    .prediction(from: inputs[.sepiaBrown]   as! Acrylic_Sepia_BrownInput)).Sepia_Brown,
                .burntUmber     : Acrylic_Burnt_UmberOutput(features:   try models[.burntUmber]!    .prediction(from: inputs[.burntUmber]   as! Acrylic_Burnt_UmberInput)).Burnt_Umber,
                .white          : Acrylic_WhiteOutput(features:         try models[.white]!         .prediction(from: inputs[.white]        as! Acrylic_WhiteInput)).White
            ]
            
            
        } catch {
            print(error)
        }
    }
}
