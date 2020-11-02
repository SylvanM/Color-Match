//
//  AC+ActionsUtil.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/27/20.
//

import Foundation
import UIKit

extension UIAlertController {
    
    func addActions(actions: [UIAlertAction]) {
        for action in actions {
            self.addAction(action)
        }
    }
    
    func addActions(actions: UIAlertAction...) {
        addActions(actions: actions)
    }
    
}

extension UIAlertAction {
    
    /**
     * The default "Cancel" action
     */
    static let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    /**
     * The default "okay" action
     */
    static let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
    
}
