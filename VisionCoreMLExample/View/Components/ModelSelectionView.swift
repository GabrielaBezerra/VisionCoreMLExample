//
//  ModelSelectionView.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 13/01/21.
//

import Foundation
import UIKit

class ModelSelectionView: UIView {

    weak var delegate: ModelSelectionViewDelegate!

    // MARK: - Model
    private let models: [ModelOption] = ModelOption.allCases

    // MARK: - Views
    private let frameRect: CGRect = CGRect(
        x: UIScreen.main.bounds.midX-125,
        y: UIScreen.main.bounds.midY-80,
        width: 250,
        height: 160
    )

    private lazy var modelPicker: UIPickerView = {
        let picker = UIPickerView(frame: .zero)
        picker.backgroundColor = UIColor.white
        picker.tintColor = UIColor.systemPurple
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()

    private lazy var okButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("OK", for: .normal)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(confirmModel), for: .touchUpInside)
        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            modelPicker,
            okButton
        ])

        stack.alignment = .fill
        stack.distribution = .fill
        stack.axis = .vertical
        stack.frame = CGRect(origin: .zero, size: self.bounds.size)

        stack.clipsToBounds = true
        self.layer.masksToBounds = true

        return stack
    }()

    // MARK: - Initialization Functions
    init(_ initialOption: ModelOption?) {
        super.init(frame: frameRect)

        self.backgroundColor = .white
        self.layer.cornerRadius = 7

        self.addSubview(stack)

        let initialIndex: Int = models.firstIndex(where: { initialOption == $0 }) ?? 0
        modelPicker.selectRow(initialIndex, inComponent: 0, animated: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc private func confirmModel() {
        let selectedModel = models[modelPicker.selectedRow(inComponent: 0)]
        delegate.didSelect(model: selectedModel)
        self.removeFromSuperview()
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension ModelSelectionView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return models.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return models[row].rawValue
    }

}
