//
//  ModelRunnerDelegate.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 22/01/21.
//

import Foundation
import Vision

protocol ModelProcessorDelegate: class {
    func justProcessed()
    func didProcess(results: [ObservationResult<VNRecognizedObjectObservation>], description: String)
    func didProcess(results: [ObservationResult<VNClassificationObservation>], description: String)
}
