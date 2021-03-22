//
//  ModelRunner.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 22/01/21.
//

import Foundation
import UIKit
import CoreMedia
import CoreVideo

protocol ModelProcessor {
    var delegate: ModelProcessorDelegate? { get set }

    func updateClassifications(for image: UIImage)
    func updateClassifications(for sampleBuffer: CMSampleBuffer)
}
