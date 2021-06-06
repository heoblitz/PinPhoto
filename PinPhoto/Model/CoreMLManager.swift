//
//  CoreMLManager.swift
//  PinPhoto
//
//  Created by won heo on 2021/01/06.
//  Copyright © 2021 won heo. All rights reserved.
//

import UIKit
import CoreML
import Vision

final class CoreMLManager {
    // update -> request -> process
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            
            let model = try VNCoreMLModel(for: UnsplashClassifier(configuration: config).model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request, error in
                self?.processClassification(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch let error {
            fatalError("Faild to load ML \(error.localizedDescription)")
        }
    }()
    
    private var classficationCache: [String:Float] = [:]

    func processClassification(for request: VNRequest, error: Error?) {
        guard let results = request.results, let classifications = results as? [VNClassificationObservation] else { return }
        
        if classifications.isEmpty {
            print("Nothing")
        } else {
            let topClassifications = classifications.prefix(2)
            
            topClassifications.forEach {
                let identifier: String = $0.identifier
                let confidence: Float = $0.confidence
                
                if let value = classficationCache[identifier] {
                    classficationCache[identifier] = value + confidence
                } else {
                    classficationCache[identifier] = confidence
                }
            }
        }
    }
    
    func requestClassifications(for images: [UIImage], completeHandler: @escaping ([String:Float]) -> ()) {
        let ciImages: [CIImage] = images.compactMap { CIImage(image: $0) }
        
        let coreMLQueue = DispatchQueue(label: "coreMLFetchQueue", qos: .userInitiated)
        let coreMLGroup = DispatchGroup()
        
        for ciImage in ciImages {
            coreMLQueue.async(group: coreMLGroup, execute: {
                let hander = VNImageRequestHandler(ciImage: ciImage)
                
                do {
                    try hander.perform([self.classificationRequest])
                } catch {
                    print(error.localizedDescription)
                }
            })
        }

        coreMLGroup.notify(queue: coreMLQueue, execute: { [unowned self] in
            print(self.classficationCache)
            completeHandler(self.classficationCache)
        })
    }
}
    
