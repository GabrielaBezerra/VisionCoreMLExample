//
//  ImageClassifier.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 13/01/21.
//

import Foundation
import UIKit
import Vision

class ImageClassifier: ModelProcessor {

    weak var delegate: ModelProcessorDelegate?

    // MARK: - Model
    private var classificationRequest: VNCoreMLRequest!

    // MARK: - Initialization Functions
    init(_ model: ModelOption) {
        self.classificationRequest = createRequest(of: model)
        print("allocated ImageClassifier, ClassifierDelegate and Classification Request")
    }

    deinit {
        self.classificationRequest = nil
        self.delegate = nil
        print("deallocated ImageClassifier, ClassifierDelegate and Classification Request")
    }

    // MARK: - Image Classification Setup
    private func createRequest(of option: ModelOption) -> VNCoreMLRequest {
        do {
            let model = try VNCoreMLModel(for: option.model)

            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .scaleFit
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }

    // MARK: - Perform Requests

    // Usado no processamento de uma só imagem vindo da camera do dispotivo ou da galeria
    func updateClassifications(for image: UIImage) {
        delegate?.justProcessed()

        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))

        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }

        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }

    // Usado no processamento de video vindo da camera do dispotivo
    func updateClassifications(for sampleBuffer: CMSampleBuffer) {
        delegate?.justProcessed()

        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        let sequenceRequestHandler = VNSequenceRequestHandler()
        do {
            try sequenceRequestHandler.perform([classificationRequest], on: pixelBuffer, orientation: .up)
        } catch {
            print(error)
        }
    }

    // MARK: - Proccess Classifications on Requests Callback
    private func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            guard let results = request.results else {
                self.delegate?.didProcess(results: [ObservationResult<VNClassificationObservation>](),
                                          description: "Unable to classify image.")
                return
            }

            guard let classifications = results as? [VNClassificationObservation] else {
                print("Results are not VNClassificationObservation")
                return
            }

            if classifications.isEmpty {
                self.delegate?.didProcess(results: [ObservationResult<VNClassificationObservation>](),
                                          description: "Nothing Recognized")
            } else {
                let observations = Array(classifications.prefix(3))

                let topClassifications: [ObservationResult<VNClassificationObservation>] = observations.compactMap {
                        ObservationResult<VNClassificationObservation>(observation: $0, boundingBox: nil)
                }

                self.delegate?.didProcess(
                    results: topClassifications,
                    description: "Classification Results"
                )
            }
        }
    }

}
