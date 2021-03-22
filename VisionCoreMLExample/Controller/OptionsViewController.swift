//
//  OptionsViewController.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 12/01/21.
//

import Foundation
import UIKit

class OptionsViewController: UIViewController {

    // MARK: - Model
    let manager: ModelManager!

    // MARK: - View
    lazy var optionsView: UIView = {
        OptionsView(
            devicePictureCameraAction: { [weak self] in
                self?.present(PictureCameraViewController(self!.manager), animated: true)
            },
            deviceVideoCameraAction: { [weak self] in
                self?.present(DeviceCameraViewController(self!.manager), animated: true)
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

    // MARK: - Managing the View
    override func loadView() {
        super.loadView()
        self.view = optionsView
    }

}
