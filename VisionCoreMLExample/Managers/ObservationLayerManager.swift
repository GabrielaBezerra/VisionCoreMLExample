//
//  ObservationLayerManager.swift
//  VisionCoreMLExample
//
//  Created by Gabriela Bezerra on 16/03/21.
//

import Foundation
import UIKit

class ObservationLayerManager {

    private static func createBoundingBox(forRegionOfInterest: CGRect, in rootLayer: CALayer) -> CGRect {

        let imageWidth = rootLayer.bounds.width
        let imageHeight = rootLayer.bounds.height

        // Begin with input rect.
        var rect = forRegionOfInterest

        // Reposition origin.
        rect.origin.x *= imageWidth
        rect.origin.x += rootLayer.bounds.origin.x
        rect.origin.y = (1 - rect.origin.y) * imageHeight + rootLayer.bounds.origin.y

        // Rescale normalized coordinates.
        rect.size.width *= imageWidth
        rect.size.height *= imageHeight

        return rect
    }

    private static func createShapeLayer(color: UIColor, frame: CGRect) -> CAShapeLayer {
        // Create a new layer.
        let layer = CAShapeLayer()

        // Configure layer's appearance.
        layer.cornerRadius = 7
        layer.name = "Found Object"
        layer.backgroundColor = CGColor(
            colorSpace: CGColorSpaceCreateDeviceRGB(),
            components: [1, 1, 1, 0.35]
        )

        // Locate the layer.
        layer.anchorPoint = .zero
        layer.frame = frame
        layer.masksToBounds = true

        // Transform the layer to have same coordinate system as the imageView underneath it.
        layer.transform = CATransform3DMakeScale(1, -1, 1)

        return layer
    }

    private static func createTextSubLayerInBounds(info: String, bounds: CGRect) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"

        let formattedString = NSMutableAttributedString(string: info)
        let largeFont = UIFont(name: "Helvetica", size: 11)!
        formattedString.addAttributes(
            [
                NSAttributedString.Key.font: largeFont,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ],
            range: NSRange(location: 0, length: info.count)
        )

        textLayer.string = formattedString

        textLayer.bounds = CGRect(x: 0, y: 0, width: 100, height: 20)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.contentsScale = 2.0  // retina rendering

        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: .pi/0.5).scaledBy(x: 1.0, y: -1.0))

        return textLayer
    }

    static func createObservationBox(description: String, boundingBox: CGRect, in rootLayer: CALayer) -> CAShapeLayer {
        let normalizedBoundingBox = createBoundingBox(forRegionOfInterest: boundingBox, in: rootLayer)
        let boxLayer = createShapeLayer(color: .white, frame: normalizedBoundingBox)
        let textLayer = self.createTextSubLayerInBounds(info: description, bounds: boxLayer.bounds)
        boxLayer.addSublayer(textLayer)
        return boxLayer
    }

}
