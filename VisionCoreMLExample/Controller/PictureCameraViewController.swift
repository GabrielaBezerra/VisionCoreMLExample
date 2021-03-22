//
//  VideoViewController.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 13/01/21.
//

import Foundation
import UIKit
import CoreML
import Vision
import ImageIO

class PictureCameraViewController: UIViewController {

    // MARK: - Model
    var manager: ModelManager? {
        didSet {
            manager?.delegate = self

            if oldValue == nil {
                self.pictureCameraView.resultsLabel.text = "Add a photo."
            }

            guard let manager = manager else {
                self.pictureCameraView.resultsLabel.text = "Choose a model."
                return
            }

            if let image = self.pictureCameraView.imageView.image {
                manager.classify(image)
            }
        }
    }

    // MARK: - Views
    lazy var pictureCameraView: PictureCameraView = {
        PictureCameraView(
            dismissAction: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            },
            chooseModelHandler: { [weak self] model in
                self?.manager = ModelManager.load(model)
            },
            takePictureHandler: { [weak self] in
                self?.takePicture()
            },
            unloadAllHandler: { [weak self] in
                self?.manager = nil
                self?.pictureCameraView.imageView.image = nil
            }
        )
    }()

    // MARK: - Initialization Functions
    init(_ manager: ModelManager) {
        self.manager = manager
        super.init(nibName: nil, bundle: nil)

        self.manager?.delegate = self
        if let image = self.pictureCameraView.imageView.image {
            self.manager?.classify(image)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Managing Views
    override func loadView() {
        super.loadView()
        self.view = pictureCameraView
    }

}

// MARK: - Handling the Results from ML processing
extension PictureCameraViewController: ModelManagerDelegate {
    func justFound() {
        //reset boundingBox drawings
        self.pictureCameraView.resultsLabel.text = "\(manager!.option.rawValue)"
        self.pictureCameraView.imageView.layer.sublayers = nil
    }

    func found(_ info: String, boundingBox: CGRect?) {

        if let boundingBox = boundingBox {
            self.pictureCameraView.showObservationBox(description: info, boundingBox: boundingBox)
        }

        self.pictureCameraView.resultsLabel.text += "\n"+info
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension PictureCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func takePicture() {
        // Show options for the source picker only if the camera is available.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }

        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }

        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(photoSourcePicker, animated: true)
    }

    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }

    // MARK: - Handling Image Picker Selection
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let info = Dictionary(uniqueKeysWithValues: info.map {key, value in (key.rawValue, value)})

        picker.dismiss(animated: true)

        // We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
        if let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
            pictureCameraView.imageView.image = image
            manager?.classify(image)
        }
    }
}
