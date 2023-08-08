//
//  ModelManagerDelegate.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 22/01/21.
//

import Foundation
import UIKit

protocol ModelManagerDelegate: AnyObject {
    func justFound()
    func found(_ description: String, boundingBox: CGRect?)
}
