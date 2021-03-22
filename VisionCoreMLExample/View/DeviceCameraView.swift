//
//  DeviceCameraView.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 22/01/21.
//

import Foundation
import UIKit

class DeviceCameraView: UIView {

    // MARK: - Event Handlers
    private let dismissAction: () -> Void
    private let chooseModelHandler: (ModelOption) -> Void

    // MARK: - Views
    let resultsLabel: ResultsLabel = ResultsLabel()

    let instructionsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        label.textColor = .white
        label.text = "Toque na tela para mudar a camera."
        return label
    }()

    private lazy var dismissButton: OptionButton = OptionButton(
        systemName: "xmark",
        action: dismissAction
    )

    lazy var configUI: ConfigUI = {
        let view = ConfigUI()
        view.chooseModelAction = chooseModelHandler
        return view
    }()

    // MARK: - Initialization Functions
    init(dismissAction: @escaping () -> Void,
         chooseModelHandler: @escaping (ModelOption) -> Void) {

        self.dismissAction = dismissAction
        self.chooseModelHandler = chooseModelHandler

        super.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - View Code
extension DeviceCameraView: ViewCode {
    func buildViewHierarchy() {
        self.addSubview(resultsLabel)
        self.addSubview(instructionsLabel)
        self.addSubview(dismissButton)
        self.addSubview(configUI)
        self.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints.toggle()
        }
    }

    func setupContraints() {
        NSLayoutConstraint.activate([
            resultsLabel.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -25
            ),
            resultsLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 35
            ),

            instructionsLabel.centerXAnchor.constraint(
                equalTo: self.centerXAnchor
            ),
            instructionsLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 15
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

    func setupAdditionalConfiguration() { }

}
