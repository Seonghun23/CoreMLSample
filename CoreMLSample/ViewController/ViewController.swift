//
//  ViewController.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/06.
//

import UIKit

final class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let predictionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let predictionResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 2
        label.text = "Predictor is Initializing"
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let predictor: ImagePredictable
    private let predictionsToShow: Int = 2
    
    init(predictor: ImagePredictable) {
        self.predictor = predictor
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        predictor.initialize { [weak self] in
            self?.updatePredictionLabel("Ready for Prediction")
            self?.showButtons()
        }
    }
    
    private func setLayout() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        imageView.addSubview(predictionView)
        NSLayoutConstraint.activate([
            predictionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            predictionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            predictionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])

        predictionView.addSubview(predictionResultLabel)
        NSLayoutConstraint.activate([
            predictionResultLabel.topAnchor.constraint(equalTo: predictionView.topAnchor, constant: 20),
            predictionResultLabel.leadingAnchor.constraint(equalTo: predictionView.leadingAnchor, constant: 20),
            predictionResultLabel.bottomAnchor.constraint(equalTo: predictionView.bottomAnchor, constant: -20),
        ])

        predictionView.addSubview(cameraButton)
        NSLayoutConstraint.activate([
            cameraButton.leadingAnchor.constraint(greaterThanOrEqualTo: predictionResultLabel.trailingAnchor, constant: 10),
            cameraButton.centerYAnchor.constraint(equalTo: predictionView.centerYAnchor)
        ])
        cameraButton.setContentCompressionResistancePriority(.required, for: .horizontal)

        predictionView.addSubview(albumButton)
        NSLayoutConstraint.activate([
            albumButton.leadingAnchor.constraint(equalTo: cameraButton.trailingAnchor, constant: 10),
            albumButton.trailingAnchor.constraint(equalTo: predictionView.trailingAnchor, constant: -20),
            albumButton.centerYAnchor.constraint(equalTo: predictionView.centerYAnchor)
        ])
        albumButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}

extension ViewController {
    func userSelectedPhoto(_ photo: UIImage) {
        updateImage(photo)
        updatePredictionLabel("Making predictions for the photo...")
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.classifyImage(photo)
        }
    }
    
    private func updateImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

    private func updatePredictionLabel(_ message: String) {
        DispatchQueue.main.async {
            self.predictionResultLabel.text = message
        }
    }
    
    private func showButtons() {
        DispatchQueue.main.async {
            self.cameraButton.isHidden = false
            self.albumButton.isHidden = false
        }
    }
}

extension ViewController {
    private func classifyImage(_ image: UIImage) {
        do {
            try self.predictor.makePredictions(
                for: image,
                   completionHandler: { [weak self] result in
                       guard let self = self else { return }
                       
                       switch result {
                       case .success(let predictions):
                           let formattedPredictions = self.formatPredictions(predictions)

                           let predictionString = formattedPredictions.joined(separator: "\n")
                           self.updatePredictionLabel(predictionString)
                       case .failure(let error):
                           self.updatePredictionLabel("Failure to prediction. \(error.localizedDescription)")
                       } 
                   }
            )
        } catch {
            print("Vision was unable to make a prediction...\n\n\(error.localizedDescription)")
        }
    }

    private func formatPredictions(_ predictions: [Prediction]) -> [String] {
        let topPredictions: [String] = predictions.prefix(predictionsToShow).map { prediction in
            var name = prediction.classification

            if let firstComma = name.firstIndex(of: ",") {
                name = String(name.prefix(upTo: firstComma))
            }

            return "\(name) - \(prediction.confidencePercentage)%"
        }

        return topPredictions
    }
}
