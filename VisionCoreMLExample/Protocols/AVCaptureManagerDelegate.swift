//
//  AVCaptureManagerDelegate.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 22/01/21.
//

import Foundation
import CoreMedia

protocol AVCaptureManagerDelegate: AnyObject {
    func didCapture(_ sampleBuffer: CMSampleBuffer)
}
