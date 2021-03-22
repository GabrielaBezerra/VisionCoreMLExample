//
//  OptionButton.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 20/01/21.
//

import Foundation
import UIKit

class OptionButton: UIButton {

    // MARK: - Event Handlers
    let action: () -> Void

    // MARK: - Model
    let text: String?
    let sfIconName: String?

    // MARK: - Views
    func iconImage(_ systemName: String?) -> UIImage? {
        UIImage(systemName: systemName ?? "",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
    }

    // MARK: - Initialization Functions
    init(text: String? = nil, systemName: String? = nil, action: @escaping () -> Void ) {
        self.action = action
        self.text = text
        self.sfIconName = systemName
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Laying Out Subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }

    // MARK: - View Code Setup
    func setupView() {

        self.layer.cornerRadius = 11

        self.backgroundColor = UIColor(white: 1, alpha: 0.25)
        self.tintColor = .white

        if let text = text {
            self.setTitleColor(UIColor(white: 1, alpha: 1), for: .normal)
            self.setTitle(text, for: .normal)
        } else if let icon = iconImage(sfIconName) {
            self.tintColor = UIColor(white: 1, alpha: 1)
            self.setImage(icon, for: .normal)
        }

        self.addTarget(self, action: #selector(targetAction), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc func targetAction() {
        action()
    }

}
