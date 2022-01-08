//
//  ModelDownloader.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/09.
//

import Foundation

struct ModelDownloader {
    func downloadModel(completionHandler: @escaping (URL) -> Void) {
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
    
    private var modelDescriptionURL: URL {
        FileManager.default.temporaryDirectory
            .appendingPathComponent("MobileNetV2")
            .appendingPathExtension("mlmodel")
    }
    private var modelURL: URL {
        URL(string: "https://ml-assets.apple.com/coreml/models/Image/ImageClassification/MobileNetV2/MobileNetV2.mlmodel")!
    }
}
