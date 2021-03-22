//
//  AVCaptureManager.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 22/01/21.
//

import Foundation
import UIKit
import AVFoundation
import Vision

class AVCaptureManager: NSObject {

    weak var delegate: AVCaptureManagerDelegate!

    // MARK: - View Setup States
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer!

    var detectionOverlay: CALayer!

    var delayCounter: Int = 0

    // MARK: - Model
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()

    private var position: AVCaptureDevice.Position = .back

    private let videoDataOutputQueue = DispatchQueue(
        label: "VideoDataOutput",
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem
    )

    // MARK: - Initialization Functions
    init(rootLayer: CALayer) {
        super.init()
        self.rootLayer = rootLayer
        setupAVCapture()
    }

    deinit {
        teardownAVCapture()
    }

    // MARK: - AVCapture Configuration Functions
    private func setupAVCapture() {
        configureSession()
        addPreviewLayer()
        setupDetectionOverlay()
        //updateDetectionLayerGeometry()
        startCaptureSession()
    }

    private func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resize
        previewLayer.frame = rootLayer.bounds
        previewLayer.connection?.videoOrientation = .landscapeRight //camera
        rootLayer.addSublayer(previewLayer)
    }

    private func getDevice() -> Device? {
        var deviceInput: AVCaptureDeviceInput?

        // Select a video device, make an input
        let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInWideAngleCamera, .builtInUltraWideCamera]
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: position
        )
        let videoDevice = discoverySession.devices.last
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
        }

        if let device = videoDevice, let input = deviceInput {
            return Device(capureDevice: device, input: input)
        } else {
            return nil
        }
    }

    private func configureSession() {

        guard let device = getDevice() else { fatalError("Could not get Device Input") }

        session.beginConfiguration()
        session.sessionPreset = .hd1920x1080 // Model image size is smaller.

        // Add a video input
        guard session.canAddInput(device.input) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(device.input)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }

        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try device.capureDevice.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions(device.capureDevice.activeFormat.formatDescription)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            device.capureDevice.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
    }

    func toggleCameraPosition() {
        self.position = (position == .front) ? .back : .front

        // Get current input
        guard let input = session.inputs.first as? AVCaptureDeviceInput else { return }

        // Begin new session configuration and defer commit
        session.beginConfiguration()
        defer { session.commitConfiguration() }

        // Create new capture device with updated position
        let newDevice: Device = getDevice()!

        // Swap capture device inputs
        session.removeInput(input)
        session.addInput(newDevice.input)
    }

    // MARK: - AVCapture Start and Stop Functions
    private func startCaptureSession() {
        session.startRunning()
    }

    // Clean up capture setup
    private func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }

    // MARK: - Detection Overlay Functions
    func setupDetectionOverlay() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        let xLayer = (rootLayer.frame.width - bufferSize.width) / 2
        let yLayer = rootLayer.frame.minY + (rootLayer.frame.height - bufferSize.height) / 2
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: xLayer,
                                         y: yLayer,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.anchorPoint = .zero
        detectionOverlay.position = CGPoint(
            x: xLayer,
            y: yLayer
        )
        rootLayer.addSublayer(detectionOverlay)
    }

    func showObservationBox(description: String, boundingBox: CGRect) {
        let boxLayer = ObservationLayerManager.createObservationBox(
            description: description,
            boundingBox: boundingBox,
            in: rootLayer
        )
        detectionOverlay.addSublayer(boxLayer)
    }

}

// MARK: - Handling Output Events Frame by Frame
extension AVCaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        if delayCounter == 20 {
            delayCounter = 0
            delegate.didCapture(sampleBuffer)
        } else {
            delayCounter += 1
        }
    }

    func captureOutput(_ captureOutput: AVCaptureOutput,
                       didDrop didDropSampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        //print("frame dropped")
    }

}
