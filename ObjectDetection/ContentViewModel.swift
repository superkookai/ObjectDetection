//
//  ContentViewModel.swift
//  ObjectDetection
//
//  Created by Weerawut Chaiyasomboon on 23/03/2568.
//

import Foundation
import SwiftUI
import Vision

@Observable
class ContentViewModel {
    var imageAnalysisRequest: VNCoreMLRequest?
    var detection: String = "No image detected"
    
    init() {
        let config = MLModelConfiguration()
        
        guard let resnet = try? Resnet50(configuration: config),
              let resnetVNCoreMLModel = try? VNCoreMLModel(for: resnet.model) else { return }
        
        self.imageAnalysisRequest = VNCoreMLRequest(model: resnetVNCoreMLModel) { request, error in
            if let error {
                print("Error image analysis: \(error.localizedDescription)")
                return
            }
            self.process(request: request)
        }
    }
    
    func detectObject(uiImage: UIImage) {
        self.detection = ""
        guard let ciImage = CIImage(image: uiImage) else { return }
        
        let handler = VNImageRequestHandler(ciImage: ciImage)
        guard let imageAnalysisRequest else { return }
        do {
            try handler.perform([imageAnalysisRequest])
        } catch {
            
        }
    }
    
    func process(request: VNRequest) {
        guard let results = request.results as? [VNClassificationObservation],
                let dominateResult = results.first else { return }
        
        self.detection = "\(Int(dominateResult.confidence * 100))% \(dominateResult.identifier)"
        
    }
}
