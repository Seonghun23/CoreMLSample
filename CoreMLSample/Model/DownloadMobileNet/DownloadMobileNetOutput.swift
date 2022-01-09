//
//  DownloadMobileNetOutput.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/09.
//

import CoreML

class DownloadMobileNetOutput: MLFeatureProvider {
    // Source provided by CoreML
    private let provider : MLFeatureProvider
    
    // Probability of each category as dictionary of strings to doubles
    lazy var classLabelProbs: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "classLabelProbs")!.dictionaryValue as! [String : Double]
    }()

    // Most likely image category as string value
    lazy var classLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.stringValue
    }()
    
    // MARK: - MLFeatureProvider
    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }
    
    // MARK: - Initializer
    init(features: MLFeatureProvider) {
        self.provider = features
    }
}
