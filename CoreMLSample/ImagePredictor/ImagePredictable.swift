//
//  ImagePredictable.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/08.
//

import UIKit

protocol ImagePredictable {
    func initialize()
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws
}

typealias ImagePredictionHandler = (_ predictions: [Prediction]?, _ error: Error?) -> Void
