//
//  ObservationResult.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 25/01/21.
//

import Foundation
import UIKit

struct ObservationResult<ObservationType> {
    let observation: ObservationType
    var boundingBox: CGRect! = nil
}
