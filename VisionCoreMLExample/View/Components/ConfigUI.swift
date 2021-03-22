//
//  ConfigUI.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 13/01/21.
//

import Foundation
import UIKit

class ConfigUI: UIView {

    // MARK: - Event Handlers
    var chooseModelAction: (ModelOption) -> Void = { _ in }
    var unloadAllAction: () -> Void = { }
    var takePictureAction: () -> Void = { }

    // MARK: - Model
    var selectedModel: ModelOption?

    // MARK: - Views
    lazy var cameraButton: UIButton! = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "camera.circle.fill", withConfiguration: configuration)

        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 11
        button.addTarget(self, action: #selector(takePicture), for: .touchUpInside)
        return button
    }()

    lazy var unloadAllButton: UIButton! = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "trash.circle.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 11
        button.addTarget(self, action: #selector(unloadAll), for: .touchUpInside)
        return button
    }()

    lazy var chooseModelButton: UIButton! = {
        let button = UIButton()
        let configuration = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "m.circle.fill", withConfiguration: configuration)
        button.setImage(image, for: .normal)
        button.backgroundColor = UIColor(white: 1, alpha: 0.5)
        button.tintColor = .white
        button.layer.cornerRadius = 11
        button.addTarget(self, action: #selector(chooseModel), for: .touchUpInside)
        return button
    }()

    lazy var modelSelectionView: ModelSelectionView = {
        let view = ModelSelectionView(selectedModel)
        view.delegate = self
        return view
    }()

    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ chooseModelButton ])
        stack.contentMode = .scaleAspectFill
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 10
        stack.layer.cornerRadius = 11
        return stack
    }()

    // MARK: - Initialization Functions
    init(unloadAll: Bool = false, camera: Bool = false) {
        super.init(frame: .zero)
        self.isUserInteractionEnabled = true

        self.backgroundColor = UIColor(white: 1, alpha: 0.25)
        self.layer.cornerRadius = 11

        if camera {
            stack.addArrangedSubview(cameraButton)
        }

        if unloadAll {
            stack.addArrangedSubview(unloadAllButton)
        }

        self.addSubview(stack)
        self.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 15
            ),
            stack.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -15
            ),
            stack.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 15
            ),
            stack.bottomAnchor.constraint(
                equalTo: self.bottomAnchor,
                constant: -15
            ),

            chooseModelButton.widthAnchor.constraint(
                equalTo: chooseModelButton.heightAnchor
            )
        ])

        if camera {
            NSLayoutConstraint.activate([
                cameraButton.widthAnchor.constraint(
                    equalToConstant: 50
                ),
                cameraButton.widthAnchor.constraint(
                    equalTo: cameraButton.heightAnchor
                )
            ])
        }

        if unloadAll {
            NSLayoutConstraint.activate([
                unloadAllButton.widthAnchor.constraint(
                    equalTo: unloadAllButton.heightAnchor
                )
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func chooseModel(_ sender: UIBarButtonItem) {
        toggleActionButtons()
        self.superview!.addSubview(modelSelectionView)
    }

    @objc func unloadAll(_ sender: UIBarButtonItem) {
        unloadAllAction()
    }

    @objc func takePicture() {
        takePictureAction()
    }

    func toggleActionButtons() {
        self.chooseModelButton.isEnabled.toggle()
        self.cameraButton.isEnabled.toggle()
        self.unloadAllButton.isEnabled.toggle()
    }
}

// MARK: - ModelSelectionDelegate
extension ConfigUI: ModelSelectionViewDelegate {
    func didSelect(model: ModelOption) {
        toggleActionButtons()
        chooseModelAction(model)
    }
}
