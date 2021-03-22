//
//  OptionsView.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 21/01/21.
//

import Foundation
import UIKit

class OptionsView: UIView {

    // MARK: - Event Handlers
    private let devicePictureCameraAction: () -> Void
    private let deviceVideoCameraAction: () -> Void

    // MARK: - Views
    lazy var deviceVideoCameraButton: OptionButton! = OptionButton(
        text: "Device Video Camera View",
        action: deviceVideoCameraAction
    )

    lazy var devicePictureCameraButton: OptionButton! = OptionButton(
        text: "Device Picture Camera View",
        action: devicePictureCameraAction
    )

    // MARK: - Initialization Functions
    init(devicePictureCameraAction: @escaping () -> Void,
         deviceVideoCameraAction: @escaping () -> Void) {

        self.deviceVideoCameraAction = deviceVideoCameraAction
        self.devicePictureCameraAction = devicePictureCameraAction

        super.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Observing View Related Changes
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupView()
    }

}

// MARK: - View Code
extension OptionsView: ViewCode {

    func buildViewHierarchy() {
        self.addSubview(deviceVideoCameraButton)
        self.addSubview(devicePictureCameraButton)
        self.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setupContraints() {
        NSLayoutConstraint.activate([
            deviceVideoCameraButton.widthAnchor.constraint(
                equalToConstant: 300
            ),
            deviceVideoCameraButton.heightAnchor.constraint(
                equalToConstant: 100
            ),
            deviceVideoCameraButton.centerYAnchor.constraint(
                equalTo: self.centerYAnchor
            ),
            deviceVideoCameraButton.centerXAnchor.constraint(
                equalTo: self.centerXAnchor,
                constant: -170
            ),

            devicePictureCameraButton.widthAnchor.constraint(
                equalToConstant: 300
            ),
            devicePictureCameraButton.heightAnchor.constraint(
                equalToConstant: 100
            ),
            devicePictureCameraButton.centerYAnchor.constraint(
                equalTo: self.centerYAnchor
            ),
            devicePictureCameraButton.centerXAnchor.constraint(
                equalTo: self.centerXAnchor,
                constant: 170
            )
        ])
    }

}
