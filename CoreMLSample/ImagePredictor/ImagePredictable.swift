//
//  ImagePredictable.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/08.
//

import UIKit

protocol ImagePredictable {
    func initialize(completionHandler: (() -> Void)?)
    func makePredictions(for photo: UIImage, completionHandler: @escaping ImagePredictionHandler) throws
}

typealias ImagePredictionHandler = (_ result: Result<[Prediction], Error>) -> Void
