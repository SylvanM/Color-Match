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
        
        
        
        for key in pigments.keys {
            pigmentBars[key]?.setProgress(Float(pigments[key]!), animated: true)
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
