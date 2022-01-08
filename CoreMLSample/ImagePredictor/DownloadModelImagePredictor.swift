//
//  DownloadModelImagePredictor.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/08.
//

import Vision
import UIKit

final class DownloadModelImagePredictor: ImagePredictable {
    
    func initialize(completionHandler: (() -> Void)?) {
        downloadModel { [weak self] url in
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
    
    // TODO: Should Implement
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) {
        
    }
    
    private var imageClassifier: VNCoreMLModel?
    
    private var modelDescriptionURL: URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("MobileNetV2")
            .appendingPathExtension("mlmodel")
    }
    
    private var modelURL: URL {
        URL(string: "https://ml-assets.apple.com/coreml/models/Image/ImageClassification/MobileNetV2/MobileNetV2.mlmodel")!
    }
    
    private func downloadModel(completionHandler: @escaping (URL) -> Void) {
        URLSession.shared.dataTask(with: modelURL) { data, response, error in
            if let error = error {
                fatalError("Failure to download - error(\(error.localizedDescription)).")
            }
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            
            guard 200..<300 ~= statusCode else {
                fatalError("Failure to download - code: \(statusCode)")
            }
            
            guard let data = data else {
                fatalError("Downloaded data is wrong.")
            }
            
            do {
                try data.write(to: self.modelDescriptionURL)
                completionHandler(self.modelDescriptionURL)
            } catch let error {
                fatalError("Failure to save model - error(\(error.localizedDescription)")
            }
        }.resume()
    }
}
