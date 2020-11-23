//
//  ViewController.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/6/20.
//

import UIKit
import AVFoundation

typealias MVC = MainViewController

class MainViewController: UIViewController {
    
    // MARK: Developer Properties
    
    /// ID Counter
    ///
    /// Incremements every time a color is scanned.
    var idCounter: Int = 1
    
    // MARK: AV Properties
    
    static var pixelWindowSize = 8
        
//        : Int {
//        Settings.selectionWindowSize
//    }
    
    let captureSession  = AVCaptureSession()
    let cameraLayer     = AVCaptureVideoPreviewLayer()
    let serialQueue     = DispatchQueue.main
    var videoOutput     = AVCaptureVideoDataOutput()

    @IBOutlet var cameraView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    // MARK: Interface Properties
    
    @IBOutlet weak var captureButton: UIButton!
    
    // MARK: View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.bounds)
        print(self.cameraView.bounds)
        cameraLayer.frame = cameraView.bounds
        setupSession()
        
        
        
        cameraView.layer.addSublayer(cameraLayer)
        view.sendSubviewToBack(cameraView)
        view.bringSubviewToFront(colorView)
        let colorlib = ColorLibraryObject()
        colorlib.saveLibrary()
        
        // Light Slider
        
        // by default the light should be off
//        lightSlider.setValue(0, animated: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraLayer.session?.startRunning()
    }
    
    // MARK: View Functions
    
    func showAverageColor(pixels: [UInt32]) {
        
        let strippedRGBs = pixels.map { $0 & 0xFFFFFF }
        var averages: (red: CGFloat, blue: CGFloat, green: CGFloat) = (red: 0, blue: 0, green: 0)
        
        for rgb in strippedRGBs {
            averages.red    += CGFloat((rgb & 0xFF0000) >> 16)
            averages.green  += CGFloat((rgb & 0x00FF00) >> 8 )
            averages.blue   += CGFloat((rgb & 0x0000FF) >> 0 )
        }
        
        averages.red    /= CGFloat(255 * strippedRGBs.count)
        averages.green  /= CGFloat(255 * strippedRGBs.count)
        averages.blue   /= CGFloat(255 * strippedRGBs.count)
        
        let color = UIColor(red: averages.red, green: averages.green, blue: averages.blue, alpha: 1)
        colorView.tintColor = color
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        captureSession.stopRunning()
        
        if let colorVC = segue.destination as? ColorViewController {
            colorVC.color = colorView.tintColor!
        }
    }

    // MARK: Interface Actions
    
    
    @IBAction func captureButtonWasPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "show_color_view", sender: self)
        
    }
    
}

