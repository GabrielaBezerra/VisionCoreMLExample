//
//  PictureCameraView.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 26/01/21.
//

import Foundation
import UIKit
import Vision

class PictureCameraView: UIView {

    // MARK: - Event Handlers
    private let dismissAction: () -> Void
    private let chooseModelHandler: (ModelOption) -> Void
    private let takePictureHandler: () -> Void
    private let unloadAllHandler: () -> Void

    // MARK: - Views
    lazy var dismissButton: OptionButton = OptionButton(
        systemName: "xmark",
        action: dismissAction
    )

    let resultsLabel: ResultsLabel = {
        let label = ResultsLabel()
        label.text = "Take a picture or choose a model"
        return label
    }()

    lazy var imageView: UIImageView! = {
        let view = UIImageView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()

    lazy var configUI: ConfigUI = {
        let view = ConfigUI(unloadAll: true, camera: true)
        view.chooseModelAction = chooseModelHandler
        view.takePictureAction = takePictureHandler
        view.unloadAllAction = unloadAllHandler
        return view
    }()

    func showObservationBox(description: String, boundingBox: CGRect) {
        let boxLayer = ObservationLayerManager.createObservationBox(
            description: description,
            boundingBox: boundingBox,
            in: imageView.layer
        )
        imageView.layer.addSublayer(boxLayer)
    }

    // MARK: - Initialization Functions
    init(dismissAction: @escaping () -> Void,
         chooseModelHandler: @escaping (ModelOption) -> Void,
         takePictureHandler: @escaping () -> Void,
         unloadAllHandler: @escaping () -> Void) {

        self.dismissAction = dismissAction
        self.chooseModelHandler = chooseModelHandler
        self.takePictureHandler = takePictureHandler
        self.unloadAllHandler = unloadAllHandler

        super.init(frame: UIScreen.main.bounds)

        self.setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - View Code
extension PictureCameraView: ViewCode {
    func buildViewHierarchy() {
        self.addSubview(imageView)
        self.addSubview(resultsLabel)
        self.addSubview(configUI)
        self.addSubview(dismissButton)
        self.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }

    //swiftlint: disable function_body_length
    func setupContraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            ),
            imageView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor
            ),
            imageView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor
            ),
            imageView.topAnchor.constraint(
                equalTo: self.topAnchor
            ),

            resultsLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -25
            ),
            resultsLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 35
            ),
            resultsLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: self.trailingAnchor,
                constant: -25
            ),

            configUI.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -35
            ),
            configUI.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 50
            ),

            dismissButton.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 20
            ),
            dismissButton.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 20
            ),
            dismissButton.heightAnchor.constraint(
                equalToConstant: 35
            ),
            dismissButton.heightAnchor.constraint(
                equalTo: dismissButton.widthAnchor
            )
        ])
    }

    func reloadView() {
        configUI.removeFromSuperview()
        dismissButton.removeFromSuperview()

        self.addSubview(configUI)
        self.addSubview(dismissButton)

        NSLayoutConstraint.activate([
            configUI.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -35
            ),
            configUI.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 50
            ),

            dismissButton.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 20
            ),
            dismissButton.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 20
            ),
            dismissButton.heightAnchor.constraint(
                equalToConstant: 35
            ),
            dismissButton.heightAnchor.constraint(
                equalTo: dismissButton.widthAnchor
            )
        ])
    }
}
