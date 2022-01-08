//
//  ViewController+PhotoPicker.swift
//  CoreMLSample
//
//  Created by Seonghun Kim on 2022/01/08.
//

import PhotosUI

extension ViewController: PHPickerViewControllerDelegate {
    var photoPicker: PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images

        let photoPicker = PHPickerViewController(configuration: config)
        photoPicker.delegate = self

        return photoPicker
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: false)

        guard let result = results.first else {
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
            if let error = error {
                print("Photo picker error: \(error)")
                return
            }

            guard let photo = object as? UIImage else {
                fatalError("The Photo Picker's image isn't a/n \(UIImage.self) instance.")
            }

            self.userSelectedPhoto(photo)
        }
    }
}
