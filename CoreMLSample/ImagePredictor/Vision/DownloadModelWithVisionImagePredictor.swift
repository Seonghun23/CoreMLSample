//
//  DownloadModelWithVisionImagePredictor.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/08.
//

import Vision
import UIKit

final class DownloadModelWithVisionImagePredictor: ImagePredictable {
    
    func initialize(completionHandler: (() -> Void)?) {
        downloader.downloadModel { [weak self] url in
            guard let compiledModelURL = try? MLModel.compileModel(at: url) else {
                fatalError("Failure to get an compiled model URL.")
            }

            guard let imageClassifierModel = try? MLModel(contentsOf: compiledModelURL) else {
                fatalError("Failure to create an MobileNetV2.")
            }
            
            guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
                fatalError("Failure to create a VNCoreMLModel.")
            }
            
            self?.imageClassifier = imageClassifierVisionModel
            completionHandler?()
        }
    }
    
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) {
        let orientation = CGImagePropertyOrientation(photo.imageOrientation)

        guard let photoImage = photo.cgImage else {
            completionHandler(.failure(PredictorError.unavailableImage))
            return
        }

        do {
            let imageClassificationRequest = try createImageClassificationRequest()
            predictionHandlers[imageClassificationRequest] = completionHandler

            let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
            let requests: [VNRequest] = [imageClassificationRequest]

            try handler.perform(requests)
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
    private let downloader: ModelDownloader = ModelDownloader()
    
    private var imageClassifier: VNCoreMLModel?
    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()
    
    private func createImageClassificationRequest() throws -> VNImageBasedRequest {
        guard let imageClassifier = imageClassifier else {
            throw PredictorError.notInitialized
        }
        
        let imageClassificationRequest = VNCoreMLRequest(
            model: imageClassifier,
            completionHandler: visionRequestHandler
        )

        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
        return imageClassificationRequest
    }
    
    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }
        
        if let error = error {
            predictionHandler(.failure(error))
            return
        }

        if request.results == nil {
            predictionHandler(.failure(PredictorError.noResult))
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            predictionHandler(.failure(PredictorError.wrongResult("\(type(of: request.results))")))
            return
        }

        let predictions = observations.map { observation in
            Prediction(
                classification: observation.identifier,
                confidencePercentage: observation.confidencePercentageString
            )
        }
        predictionHandler(.success(predictions))
    }
}
