//
//  Utility.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/27/20.
//

import Foundation
import UIKit

// MARK: - Global Utility Functions

/**
 * Converts RGB array to `RGB`
 */
func convert(rgb: [Double]) -> RGB {
    (red: rgb[0], green: rgb[1], blue: rgb[2])
}

// MARK: User Interface

/**
 * Displays an alert controller
 */
func displayAlert( sender: UIViewController, title: String, description: String, actions: [UIAlertAction] = [.okay] ) {
    let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
    alertController.addActions(actions: actions)
    sender.present(alertController, animated: true, completion: nil)
}

