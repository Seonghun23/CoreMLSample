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
        label.text = "Waiting for Prediction"
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let albumButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
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
