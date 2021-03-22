//
//  ResultsLabel.swift
//  BreakfastFinder
//
//  Created by Gabriela Bezerra on 14/01/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import UIKit

class ResultsLabel: UIView {

    // MARK: - Model
    var text: String = "" {
        didSet {
            label.text = text
            if label.text?.first == "\n" {
                label.text?.removeFirst()
            }
        }
    }

    // MARK: - Views
    private lazy var bgView: UIView = {
        let bgView = UIView(frame: .zero)
        bgView.backgroundColor = UIColor(white: 1, alpha: 0.25)
        bgView.layer.cornerRadius = 11
        return bgView
    }()

    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = UIColor(white: 1, alpha: 1)
        return label
    }()

    // MARK: - Laying Out Subviews
    override func layoutSubviews() {
        super.layoutSubviews()

        self.addSubview(bgView)
        self.addSubview(label)

        self.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor
            ),
            bgView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor
            ),
            bgView.topAnchor.constraint(
                equalTo: self.topAnchor
            ),
            bgView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor
            ),

            label.topAnchor.constraint(
                equalTo: bgView.topAnchor,
                constant: 15
            ),
            label.bottomAnchor.constraint(
                equalTo: bgView.bottomAnchor,
                constant: -15
            ),
            label.leadingAnchor.constraint(
                equalTo: bgView.leadingAnchor,
                constant: 15
            ),
            label.trailingAnchor.constraint(
                equalTo: bgView.trailingAnchor,
                constant: -15
            )
        ])
    }
}
