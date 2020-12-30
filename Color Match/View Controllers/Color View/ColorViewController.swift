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
    
    /// The RGB making up the color
    var rgb: [Double] = [0, 0, 0]
    
    /// The mix of pigments for the color
    var pigments: [ColorReplicator.Paint : Double] = [
        .red            : 0,
        .yellow         : 0,
        .yellowOchre    : 0,
        .lightBlue      : 0,
        .darkBlue       : 0,
        .sepiaBrown     : 0,
        .burntUmber     : 0,
        .white          : 0
    ]
    
    
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
    
    @IBOutlet weak var saveButton: UIButton!
    
    /*
     * Properties for displaying the pigment mixture
     */
    @IBOutlet weak var redPigmentLabel: UIProgressView!
    @IBOutlet weak var yellowPigmentLabel: UIProgressView!
    @IBOutlet weak var yellowOchrePigmentLabel: UIProgressView!
    @IBOutlet weak var lightBluePigmentLabel: UIProgressView!
    @IBOutlet weak var darkBluePigmentLabel: UIProgressView!
    @IBOutlet weak var sepiaBrownPigmentLabel: UIProgressView!
    @IBOutlet weak var burntUmberPigmentLabel: UIProgressView!
    @IBOutlet weak var whitePigmentLabel: UIProgressView!
    
    @IBOutlet weak var ratioTextView: UITextView!
    
    var pigmentBars: [ColorReplicator.Paint : UIProgressView]!
    
    var colorBars:  [UIProgressView] = []
    var labels:     [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        pigmentBars = [
            .red: redPigmentLabel,
            .yellow: yellowPigmentLabel,
            .yellowOchre: yellowOchrePigmentLabel,
            .lightBlue: lightBluePigmentLabel,
            .darkBlue: darkBluePigmentLabel,
            .sepiaBrown: sepiaBrownPigmentLabel,
            .burntUmber: burntUmberPigmentLabel,
            .white: whitePigmentLabel
        ]
        
        pigmentBars.forEach { $0.value.progress = 0 }

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
        
        let replicator = ColorReplicator()
        
        replicator.calculateMixture(rgb: convert(rgb: rgb), shouldCalculateWatercolor: false, colors: &pigments)
        
        // display the pigment mixture
        
        
        
        var sortedPigments: [(ColorReplicator.Paint, Double)] = pigments.map { $0 }
        sortedPigments.sort { $0.1 < $1.1 } // sort all values by their pigment values
        
        
        
        for key in pigments.keys {
            pigmentBars[key]?.setProgress(Float(pigments[key]!), animated: true)
        }
        
        // Actually, we're just gonna pick the top 3 or 4 colors.
        
//        // Now do some statistical tests to find outliers
//
//        let q1 = sortedPigments[sortedPigments.count / 4].1
//        let q3 = sortedPigments[3 * sortedPigments.count / 4].1
//
//        let threshold = 0.8
//
//        let iqr = q3 - q1
//        let lowerFence = q1 - threshold * iqr
//        let upperFence = q3 + threshold * iqr
//
//        print(lowerFence)
//        print(upperFence)
//
//        print(sortedPigments.count)
//
//        // Get new array, excluding outliers
//        sortedPigments.removeAll { $0.1 < lowerFence || $0.1 > upperFence }
//
//        print(sortedPigments.count)
        
        var ratioColors = Array(sortedPigments.suffix(from: sortedPigments.count - 3))
        
        // calculate ratio
//        let minimum = (ratioColors.min { $0.1 < $1.1 })!.1
        
    
        for i in 0..<ratioColors.count {
            print(ratioColors[i])
            ratioColors[i].1 = round(10 * ratioColors[i].1)
        }
        
//        let total = ratioColors.reduce(0) { $0 + $1.1 }
//
//        for i in 0..<ratioColors.count {
//            print(ratioColors[i].0, ratioColors[i].1)
//        }
        
        ratioTextView.text = "\(ratioColors[0].0): \(ratioColors[0].1)\n\(ratioColors[1].0): \(ratioColors[1].1)\n\(ratioColors[2].0): \(ratioColors[2].1)\n"
        
        for pigment in sortedPigments {
            print(pigment.0, pigment.1)
        }
        
    }
    
    // MARK: Interface Actions
    
    /**
     * Called when the save button is pressed
     */
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        
        var paintType = Settings.PaintType.acrlyic
        
        
        let paintTypeChooserAC = UIAlertController(title: "Choose Paint Type", message: "What kind of paint is this?", preferredStyle: .actionSheet)
        let saveColorAC = UIAlertController(title: "Save The Color", message: "Please name the color to save it", preferredStyle: .alert)

        
        let acrylicAction = UIAlertAction(title: "Acrylic", style: .default) {_ in 
            paintTypeChooserAC.dismiss(animated: true) {
                self.present(saveColorAC, animated: true, completion: nil)
            }
        }
        let watercolorAction = UIAlertAction(title: "Watercolor", style: .default) { _ in
            paintType = .watercolor
            
            paintTypeChooserAC.dismiss(animated: true) {
                self.present(saveColorAC, animated: true, completion: nil)
            }
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        paintTypeChooserAC.addActions(actions: acrylicAction, watercolorAction, cancelAction)
        
        self.present(paintTypeChooserAC, animated: true) {
            // after this one is presented, present the "save" view controller
            
            
            saveColorAC.addTextField { textField in
                textField.placeholder = "Color Name"
            }
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                if let colorName = saveColorAC.textFields?.first?.text {
                    
                    let color = (rgb: (red: self.rgb[0], green: self.rgb[1], blue: self.rgb[2]), pigments: self.pigments)
                    
                    ColorLibraryObject.add(name: colorName, color: color, type: paintType)
                    
                    
                    
                } else {
                    // if the user didn't enter anything in the name text field, present the alert again
                    displayAlert(sender: self, title: "Missing Name", description: "Please name the color before saving") {
                        self.present(saveColorAC, animated: true, completion: nil)
                    }
                }
            }
            
            cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            saveColorAC.addActions(actions: saveAction, cancelAction)
            
            
        }
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }

}
