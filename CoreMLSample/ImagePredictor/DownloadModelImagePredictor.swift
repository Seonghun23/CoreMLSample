//
//  DownloadModelImagePredictor.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/09.
//

import UIKit
import CoreML

final class DownloadModelImagePredictor: ImagePredictable {
    func initialize(completionHandler: (() -> Void)?) {
        downloader.downloadModel { [weak self] url in
            guard let compiledModelURL = try? MLModel.compileModel(at: url) else {
                fatalError("Failure to get an compiled model URL.")
            }

            guard let imageClassifierModel = try? MLModel(contentsOf: compiledModelURL) else {
                fatalError("Failure to create an MobileNetV2.")
            }
            
            let imageClassifier = DownloadMobileNet(model: imageClassifierModel)
            
            self?.imageClassifier = imageClassifier
            completionHandler?()
        }
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
            let input = try DownloadMobileNetInput(imageWith: photoImage)
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
    
    private var imageClassifier: DownloadMobileNet?
    private let downloader: ModelDownloader = ModelDownloader()
}
