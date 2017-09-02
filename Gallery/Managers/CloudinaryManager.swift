//
//  CloudinaryManager.swift
//  Gallery
//
//  Created by test on 02/09/17.
//  Copyright © 2017 test. All rights reserved.
//

import Foundation
import Cloudinary
import Alamofire

let imagesKey = "images"


class CloudinaryManager: NSObject {
    
    static let apiKey    = "391654472879255"
    static let cloudName = "sanju-sample"
    static let presetName = "iw9lq7cn"
    
    static var images = [String]()
    static var cloudinary: CLDCloudinary?
    
    static var selectedSize: Size?
    
    static func configure() {
        
        let configuration = CLDConfiguration(cloudName: cloudName, apiKey: apiKey)
        cloudinary = CLDCloudinary(configuration: configuration)
        
        if let urls = UserDefaults.standard.array(forKey: imagesKey) as? [String] {
            images = urls
        }
        
    }
    
    static func upload(image : UIImage) {
        
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else { return }
            
            DispatchQueue.main.async {
                cloudinary?.createUploader().upload(data: imageData, uploadPreset: presetName, params: nil, progress: nil, completionHandler: { (result, error) in
                    
                    guard let result = result,
                          let publicId = result.publicId else {
                            handleError(error: error)
                            return
                    }
                    
                    images.append(publicId)

                })
            }
        }
    }
    
    static func downloadImage(publicId: String, completion: @escaping ((_ image: UIImage?, _ error: Error?) -> Void)) {
        
        guard let url = generateUrl(for: publicId) else { return }
        
        cloudinary?.createDownloader().fetchImage(url, nil, completionHandler: { (image, error) in
            
            DispatchQueue.main.async {
                completion(image, error)
            }
            
        })
        
    }
    
    static private func generateUrl(for publicId: String) -> String? {
        
        let size = selectedSize ?? Size(width: 120, heiht: 120)
        
        let transformation = CLDTransformation().setWidth(size.width).setHeight(size.heiht).setCrop(.fill)
        return  cloudinary?.createUrl().setTransformation(transformation).generate(publicId)
    }
    
    static func save() {
        UserDefaults.standard.setValue(images, forKey: imagesKey)
        UserDefaults.standard.synchronize()
    }
    
    static private func handleError(error: Error?) {
        // Show error message.
    }
}
