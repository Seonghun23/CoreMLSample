//
//  PredictorError.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/08.
//

import Foundation

enum PredictorError: Error {
    case notInitialized
    case unavailableImage
    case noResult
    case wrongResult(String)
}
