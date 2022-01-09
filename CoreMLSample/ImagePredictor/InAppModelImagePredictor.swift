//
//  InAppModelImagePredictor.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/09.
//

import UIKit
import CoreML

final class InAppModelImagePredictor: ImagePredictable {
    func initialize(completionHandler: (() -> Void)?) {
        let defaultConfig = MLModelConfiguration()
        guard let imageClassifier = try? InAppMobileNet(configuration: defaultConfig) else {
            fatalError("Failure to create an MobileNetV2.")
        }

        self.imageClassifier = imageClassifier
        completionHandler?()
    }
    
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) {
        guard let imageClassifier = imageClassifier else {
            completionHandler(.failure(PredictorError.notInitialized))
            return
        }
        
        guard let photoImage = photo.cgImage else {
            completionHandler(.failure(PredictorError.unavailableImage))
            return
        }

        do {
            let input = try InAppMobileNetInput(imageWith: photoImage)
            let output = try imageClassifier.prediction(input: input)
            let predictions = output.classLabelProbs.map { label, confidence in
                Prediction(
                    classification: label,
                    confidencePercentage: String(format: "%2.1f", confidence * 100)
                )
            }.sorted(by: { $0.confidencePercentage > $1.confidencePercentage })
            completionHandler(.success(predictions))
        } catch let error {
            completionHandler(.failure(error))
        }
        
    }
    
    private var imageClassifier: InAppMobileNet?
}
