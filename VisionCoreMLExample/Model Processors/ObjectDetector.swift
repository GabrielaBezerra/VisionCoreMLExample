//
//  ObjectDetector.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 25/01/21.
//

import Foundation
import UIKit
import Vision
import CoreML

class ObjectDetector: ModelProcessor {

    weak var delegate: ModelProcessorDelegate?

    private var detectionOverlay: CALayer! = nil

    // MARK: - Task
    var requests: [VNRequest] = []

    init(_ model: ModelOption) {
        let request = createRequest(of: model)
        self.requests = [request]
        print("allocated ObjectDetector")
    }

    // Image Classification Setup
    private func createRequest(of option: ModelOption) -> VNCoreMLRequest {
        do {
            let model = try VNCoreMLModel(for: option.model)

            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, _ in
                guard let self = self else { return }
                if let results = request.results {
                    self.process(results: results)
                }
            })
            request.imageCropAndScaleOption = .scaleFit
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }

    // MARK: - Machinery
    func updateClassifications(for image: UIImage) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
            do {
                try handler.perform(self.requests)
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    func updateClassifications(for sampleBuffer: CMSampleBuffer) {
        let imageRequestHandler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer,
            orientation: .up,
            options: [:]
        )

        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }

    func updateClassifications(for pixelBuffer: CVPixelBuffer) { }

    // MARK: - Results
    func process(results: [Any]) {
        delegate?.justProcessed()

        let observationResults: [ObservationResult<VNRecognizedObjectObservation>] = results.compactMap {
            if let observation = $0 as? VNRecognizedObjectObservation {
                return ObservationResult<VNRecognizedObjectObservation>(observation: observation,
                                                                        boundingBox: observation.boundingBox)
            }
            return nil
        }

        delegate?.didProcess(results: observationResults, description: "description")
    }

}
