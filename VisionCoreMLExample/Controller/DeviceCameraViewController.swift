//
//  LiveCameraViewController.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 20/01/21.
//

import Foundation
import UIKit
import AVFoundation
import Vision

class DeviceCameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    // MARK: - Models
    private lazy var captureManager: AVCaptureManager = {
        AVCaptureManager(rootLayer: deviceCameraView.layer)
    }()

    var manager: ModelManager

    // MARK: - View
    private lazy var deviceCameraView: DeviceCameraView = {
        DeviceCameraView(
            dismissAction: { [weak self] in
                self?.dismiss(animated: true)
            },
            chooseModelHandler: { [weak self] model in
                self?.manager = ModelManager.load(model)
                self?.manager.delegate = self
            }
        )
    }()

    // MARK: - Initialization Functions
    init(_ manager: ModelManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Managing the Views
    override func loadView() {
        super.loadView()
        self.view = deviceCameraView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        captureManager.delegate = self
        manager.delegate = self

        deviceCameraView.setupView()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        captureManager.toggleCameraPosition()
    }
}

// MARK: - Handling Frames coming from AVCapture
extension DeviceCameraViewController: AVCaptureManagerDelegate {
    func didCapture(_ sampleBuffer: CMSampleBuffer) {
        manager.classify(sampleBuffer)
    }
}

// MARK: - Handling the Results from ML processing
extension DeviceCameraViewController: ModelManagerDelegate {

    func justFound() {
        deviceCameraView.resultsLabel.text = "\(manager.option.rawValue)"
        captureManager.detectionOverlay.sublayers = nil
    }

    func found(_ info: String, boundingBox: CGRect?) {
        print("\n"+info+"\n")
        if let boundingBox = boundingBox {
            self.captureManager.showObservationBox(description: info, boundingBox: boundingBox)
        }
        deviceCameraView.resultsLabel.text += "\n"+info
    }

}
