//
//  DownloadMobileNetInput.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/09.
//

import CoreML

class DownloadMobileNetInput: MLFeatureProvider {
    var image: CVPixelBuffer

    // MARK: - MLFeatureProvider
    var featureNames: Set<String> {
        get {
            return ["image"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "image") {
            return MLFeatureValue(pixelBuffer: image)
        }
        return nil
    }
    
    // MARK: - Initializer
    init(image: CVPixelBuffer) {
        self.image = image
    }

    convenience init(imageWith image: CGImage) throws {
        self.init(image: try MLFeatureValue(cgImage: image, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }

    convenience init(imageAt image: URL) throws {
        self.init(image: try MLFeatureValue(imageAt: image, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!)
    }

    // MARK: - setImage
    func setImage(with image: CGImage) throws  {
        self.image = try MLFeatureValue(cgImage: image, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }

    func setImage(with image: URL) throws  {
        self.image = try MLFeatureValue(imageAt: image, pixelsWide: 224, pixelsHigh: 224, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }
}
