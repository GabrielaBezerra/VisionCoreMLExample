//
//  ModelSelectionViewDelegate.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 22/01/21.
//

import Foundation

protocol ModelSelectionViewDelegate: AnyObject {
    func didSelect(model: ModelOption)
}
