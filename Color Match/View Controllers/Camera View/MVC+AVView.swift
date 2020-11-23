//
//  MVC+AVView.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/16/20.
//

import Foundation
import AVFoundation
import UIKit

extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: AV Properties
    
    /// Finds the best camera on the phone to use
    var bestDevice: AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera,
                                                for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                       for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device.")
        }
    }
    
    // MARK: Functions
    
    /**
     * Sets up the capture session to gether pixel data from camera and display the camera view.
     */
    func setupSession() {
        
        var scaleFactor = self.view.bounds.width
        
        captureSession.beginConfiguration()
        
        let videoDevice = bestDevice
        
        guard
            let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            captureSession.canAddInput(videoDeviceInput)
        else {
            return
        }
        
        
        
        captureSession.addInput(videoDeviceInput)
        
        guard captureSession.canAddOutput(videoOutput) else { return }
        
        captureSession.sessionPreset = .high
        
        captureSession.addOutput(videoOutput)
        captureSession.commitConfiguration()
        
        cameraLayer.videoGravity = .resizeAspect
        cameraLayer.connection?.videoOrientation = .portrait
        
        // compute scale factor by which to zoom in the view
        scaleFactor /= cameraView.frame.width
        cameraView.transform = cameraView.transform.scaledBy(x: scaleFactor, y: scaleFactor)
        
        cameraLayer.session = captureSession
        videoOutput.setSampleBufferDelegate(self, queue: serialQueue)
        
        videoOutput.videoSettings["PixelFormatType"] = 1111970369 // this is the number that tells it we want the data in the RGBA format
        videoOutput.videoSettings["Height"] = view.bounds.height
        videoOutput.videoSettings["Width"] = view.bounds.width
        
        print(videoOutput.videoSettings!)
        
    }
    
    // MARK: AV Capture Delegate Methods
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("No image buffer.")
            return
        }
        
        CVPixelBufferLockBaseAddress(imageBuffer, .readOnly)
        
        guard let pixelBuffer = CVPixelBufferGetBaseAddress(imageBuffer) else {
            print("Could not get base address: \(imageBuffer  )")
            return
        }
        
        let byteBuffer  = pixelBuffer.assumingMemoryBound(to: UInt32.self)
        
        let pixelsPerRow = CVPixelBufferGetBytesPerRow(imageBuffer) / 4
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        var pixels = [UInt32](repeating: 0, count: MVC.pixelWindowSize * MVC.pixelWindowSize)
        var i = 0
        
        // I need to find a much much prettier way to do this
        
        var middleHeight: Int { height / 2 }
        var middleWidth:  Int { width  / 2 }
        
        let windowOffset = MVC.pixelWindowSize / 2
        
        for x in (middleWidth - windowOffset)...(middleWidth + windowOffset) {
            for y in (middleHeight - windowOffset)...(middleHeight + windowOffset) {
                if i > 63 { break }
                pixels[i] = byteBuffer[ (y * pixelsPerRow) + x ]
                i += 1
            }
        }
    
        CVPixelBufferUnlockBaseAddress(imageBuffer, .readOnly)
        
        showAverageColor(pixels: pixels)
        
    }
    
}
