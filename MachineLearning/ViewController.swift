//
//  ViewController.swift
//  MachineLearning
//
//  Created by wooky83 on 21/12/2018.
//  Copyright © 2018 wooky. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: BaseVC {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var resultTxt: UILabel!
    @IBOutlet weak var pickBtn: UIButton!
    // MARK: - Properties
    let vowels: [Character] = ["a", "e", "i", "o", "u"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        guard let image = imgView.image, let ciImage = CIImage(image: image) else {
            preconditionFailure("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
    }

    @IBAction func pickImageClicked(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .savedPhotosAlbum
        present(pickerController, animated: true)
    }
    
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else {
            preconditionFailure("fail")
        }
        self.imgView.image = image
        guard let ciImage = CIImage(image: image) else {
            preconditionFailure("couldn't convert UIImage to CIImage")
        }
        
        detectScene(image: ciImage)
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}

extension ViewController {
    
    func detectScene(image: CIImage) {
        resultTxt.text = "detecting scene..."
        

        guard let md = self.segueData as? MLModel , let model = try? VNCoreMLModel(for: md) else {
            preconditionFailure("can't load Places ML Model!!")
        }

        
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else {
                preconditionFailure("unexpected result type from VNCoreMLRequest")
            }
            
            let article = (self?.vowels.contains(topResult.identifier.first!))! ? "an" : "a"

            DispatchQueue.main.async { [weak self] in
                self?.resultTxt.text = "\(Int(topResult.confidence * 100))% it's \(article) \(topResult.identifier)"
            }
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
            }
            
        }
    }
}
