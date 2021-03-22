////
////  Extensions.swift
////  VisionCoreMLExample
////
////  Created by Gabriela Bezerra on 22/01/21.
////
//
//import Foundation
//import UIKit
//
//extension UIDeviceOrientation {
//
//    public static func exifOrientation() -> CGImagePropertyOrientation {
//        let curDeviceOrientation = UIDevice.current.orientation
//        let exifOrientation: CGImagePropertyOrientation
//
//        switch curDeviceOrientation {
//        case Self.portraitUpsideDown:  // Device oriented vertically, home button on the top
//            exifOrientation = .left
//        case Self.landscapeLeft:       // Device oriented horizontally, home button on the right
//            exifOrientation = .upMirrored
//        case Self.landscapeRight:      // Device oriented horizontally, home button on the left
//            exifOrientation = .down
//        case Self.portrait:            // Device oriented vertically, home button on the bottom
//            exifOrientation = .up
//        default:
//            exifOrientation = .up
//        }
//        return exifOrientation
//    }
//
//}
//
//extension CGSize {
//  var cgPoint: CGPoint {
//    return CGPoint(x: width, y: height)
//  }
//}
//
//extension CGPoint {
//  var cgSize: CGSize {
//    return CGSize(width: x, height: y)
//  }
//}
