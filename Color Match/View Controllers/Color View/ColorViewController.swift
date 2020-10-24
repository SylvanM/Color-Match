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
    
    var rgb: [Double] = [0, 0, 0]
    
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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var saveButton: UIButton!
    
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
        rgb = [red, green, blue].map { Double($0) }
        colorBars = [redBar, greenBar, blueBar]
        
        labels = [redLabel, greenLabel, blueLabel]
        
        // set up visuals
        
        // set up bars
        for i in 0...2 {
            labels[i].text = String(format: "%.2f", rgb[i])
            colorBars[i].progress = Float(rgb[i])
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Replicating...")
        replicateColor()
        
    }
    
    // MARK: Interface Actions
    
    /**
     * Called when the save button is pressed
     */
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Save Color", message: "What is this color's name?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // code codes here that is run when user hits save
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }

}
