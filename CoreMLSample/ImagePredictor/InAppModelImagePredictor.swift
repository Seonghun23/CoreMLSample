//
//  InAppModelImagePredictor.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/08.
//

import Vision
import UIKit

final class InAppModelImagePredictor: ImagePredictable {
    private var imageClassifier: VNCoreMLModel?
    
    func initialize() {
        let defaultConfig = MLModelConfiguration()
        guard let imageClassifier = try? MobileNetV2(configuration: defaultConfig) else {
            fatalError("Failure to create an MobileNetV2.")
        }

        let imageClassifierModel = imageClassifier.model
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("Failure to create a VNCoreMLModel.")
        }
        
        self.imageClassifier = imageClassifierVisionModel
    }
}
