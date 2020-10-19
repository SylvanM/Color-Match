//
//  ColorViewController.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/17/20.
//

import UIKit

class ColorViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The color to analyze
    var color: UIColor = .white
    
    var rgb: [CGFloat] = [0, 0, 0]
    
    // MARK: - Visual Properties
    
    /// Color View
    @IBOutlet weak var colorView: UIView!
    
    /// Red Label
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var redBar: UIProgressView!
    
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var greenBar: UIProgressView!
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var blueBar: UIProgressView!
    
    var colorBars:  [UIProgressView] = []
    var labels:     [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorView.backgroundColor = color
        var (red, green, blue): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        rgb = [red, green, blue]
        colorBars = [redBar, greenBar, blueBar]
        
        labels = [redLabel, greenLabel, blueLabel]
        
        // set up visuals
        
        // set up bars
        for i in 0...2 {
            labels[i].text = String(format: "%.2f", rgb[i])
            colorBars[i].progress = Float(rgb[i])
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Heys")
        
    }

}
