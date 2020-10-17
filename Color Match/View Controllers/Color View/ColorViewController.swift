//
//  ColorViewController.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/17/20.
//

import UIKit

class ColorViewController: UIViewController {
    
    // MARK: Properties
    
    /// The color to analyze
    var color: UIColor = .white
    
    /// Color View
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorView.backgroundColor = color
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
