//
//  ModelManager.swift
//  Vision+ML Example
//
//  Created by Gabriela Bezerra on 10/01/21.
//

import Foundation
import UIKit
import CoreML
import Vision
import ImageIO

class ModelManager {

    weak var delegate: ModelManagerDelegate?

    // MARK: - Model
    private(set) var option: ModelOption!

    // MARK: - CoreML Wrappers
    private var modelProcessor: ModelProcessor!

    // MARK: - Private Initialization Functions
    private init(option: ModelOption) {
        self.option = option
        self.modelProcessor = option.modelProcessor
        self.modelProcessor.delegate = self
        print("allocated manager and model")
    }

    deinit {
        self.option = nil
        self.modelProcessor = nil
        self.delegate = nil
        print("deallocated manager and model")
    }

    // MARK: - Static Initialization Function
    static func load(_ option: ModelOption = .mobileNetV2) -> ModelManager {
        ModelManager(option: option)
    }

    // MARK: - CoreML Wrappers
    func classify(_ image: UIImage) {
        modelProcessor.updateClassifications(for: image)
    }

    func classify(_ sampleBuffer: CMSampleBuffer) {
        modelProcessor.updateClassifications(for: sampleBuffer)
    }

}

// MARK: - Handing Results coming from CoreML Wrappers
extension ModelManager: ModelProcessorDelegate {

    func justProcessed() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.justFound()
        }
    }

    func didProcess(results: [ObservationResult<VNRecognizedObjectObservation>], description: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for result in results {
                let label = result.observation.labels[0].identifier
                let confidence = String(format: "%.2f", result.observation.confidence * 100)
                let boundingBox = result.boundingBox
                self.delegate?.found("\(confidence)% \(label)", boundingBox: boundingBox)
            }
        }
    }

    func didProcess(results: [ObservationResult<VNClassificationObservation>], description: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let filteredResults = results.filter { $0.observation.confidence > 0.05 }

            for result in filteredResults {
                let label = result.observation.identifier
                let confidence = String(format: "%.2f", result.observation.confidence * 100)
                self.delegate?.found("\(confidence)% \(label)", boundingBox: result.boundingBox)
            }

        }
    }

}
