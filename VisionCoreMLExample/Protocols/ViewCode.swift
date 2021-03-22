//
//  ViewCode.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 21/01/21.
//

import Foundation
import UIKit

protocol ViewCode: UIView {
    func buildViewHierarchy()
    func setupContraints()
    func setupAdditionalConfiguration()

    func setupView()
    func reloadView()
}

extension ViewCode {

    func setupView() {
        buildViewHierarchy()
        setupContraints()
        setupAdditionalConfiguration()
    }

    func reloadView() {
        self.subviews.forEach { $0.removeFromSuperview() }
        setupView()
    }

    func setupAdditionalConfiguration() {
        self.backgroundColor = .black
    }
}
