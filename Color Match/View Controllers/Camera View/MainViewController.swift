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
    
    // MARK: AV Properties
    
    static let pixelWindowSize = 8
    
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
        setupSession()
        
        cameraView.layer.addSublayer(cameraLayer)
        view.sendSubviewToBack(cameraView)
        view.bringSubviewToFront(colorView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraLayer.frame = cameraView.bounds
        cameraLayer.session?.startRunning()
    }
    
    
    
    // MARK: View Functions
    
    func showAverageColor(pixels: [UInt32]) {
        
        let strippedRGBs = pixels.map { $0 & 0xFFFFFF }
        var averages: (red: CGFloat, blue: CGFloat, green: CGFloat) = (red: 0, blue: 0, green: 0)
        
        for rgb in strippedRGBs {
            averages.blue    += CGFloat((rgb & 0xFF)     >> 0 )
            averages.green  += CGFloat((rgb & 0xFF00)   >> 8 )
            averages.red   += CGFloat((rgb & 0xFF0000) >> 16)
        }
        
        averages.red    /= CGFloat(255 * strippedRGBs.count)
        averages.green  /= CGFloat(255 * strippedRGBs.count)
        averages.blue   /= CGFloat(255 * strippedRGBs.count)
        
        let color = UIColor(red: averages.red, green: averages.green, blue: averages.blue, alpha: 1)
        colorView.backgroundColor = color
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        captureSession.stopRunning()
        
        if let colorVC = segue.destination as? ColorViewController {
            colorVC.color = colorView.backgroundColor!
        }
    }


}

