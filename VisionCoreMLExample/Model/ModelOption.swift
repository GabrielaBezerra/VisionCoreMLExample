//
//  ModelOption.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 13/01/21.
//

import Foundation
import CoreML

//swiftlint:disable force_try
enum ModelOption: String, CaseIterable {

    //Image Classifiers
    case mobileNetV2 = "MobileNetV2"
    case squeezeNet = "SqueezeNet"
    case resnet50 = "Resnet50FP16"

    //Object Detectors
    case yolov3Tiny = "YOLOv3Tiny"
    case yolov3 = "YOLOv3Int8LUT"

    var model: MLModel {
        switch self {
        case .mobileNetV2:
            return try! MobileNetV2(configuration: MLModelConfiguration()).model
        case .squeezeNet:
            return try! SqueezeNet(configuration: MLModelConfiguration()).model
        case .resnet50:
            return try! Resnet50FP16(configuration: MLModelConfiguration()).model
        case .yolov3:
            return try! YOLOv3Int8LUT(configuration: MLModelConfiguration()).model
        case .yolov3Tiny:
            return try! YOLOv3Tiny(configuration: MLModelConfiguration()).model
        }
    }

    var modelProcessor: ModelProcessor? {
        switch self {
        case .mobileNetV2, .squeezeNet, .resnet50:
            return ImageClassifier(self)
        case .yolov3, .yolov3Tiny:
            return ObjectDetector(self)
        }
    }

}
