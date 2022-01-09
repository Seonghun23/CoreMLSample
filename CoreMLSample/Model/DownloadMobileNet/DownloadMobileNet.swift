//
//  DownloadMobileNet.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/09.
//

import CoreML

class DownloadMobileNet {
    let model: MLModel
    
    // MARK: - Initializer
    init(model: MLModel) {
        self.model = model
    }
    
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }
    
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<InAppMobileNet, Error>) -> Void) {
        MLModel.load(contentsOf: modelURL, configuration: configuration) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let model):
                handler(.success(InAppMobileNet(model: model)))
            }
        }
    }
    
    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration()) async throws -> InAppMobileNet {
        let model = try await MLModel.load(contentsOf: modelURL, configuration: configuration)
        return InAppMobileNet(model: model)
    }
    
    // MARK: - prediction
    func prediction(input: DownloadMobileNetInput) throws -> DownloadMobileNetOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }
    
    func prediction(input: DownloadMobileNetInput, options: MLPredictionOptions) throws -> DownloadMobileNetOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return DownloadMobileNetOutput(features: outFeatures)
    }
    
    func prediction(image: CVPixelBuffer) throws -> DownloadMobileNetOutput {
        let input_ = DownloadMobileNetInput(image: image)
        return try self.prediction(input: input_)
    }
    
    func predictions(inputs: [DownloadMobileNetInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [DownloadMobileNetOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [DownloadMobileNetOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  DownloadMobileNetOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
