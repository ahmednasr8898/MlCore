//
//  ViewController.swift
//  Ml Core
//
//  Created by Ahmed Nasr on 9/23/20.
//  Copyright © 2020 Ahmed Nasr. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ShowLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePickerView = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{

            imageView.image = imagePickerView
        
        
        guard let ciImage = CIImage(image: imagePickerView) else {
            
            fatalError("ERROR")
        
            }
            
            detect(image: ciImage)
        }
    }

    @IBAction func openGallaryOnClick(_ sender: UIBarButtonItem) {
        
        present(imagePicker , animated:  true ,completion: nil)
    }
    
    
    func detect(image: CIImage){
      
        guard  let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
                fatalError("Core ML loading failed")
        }
         
        let request = VNCoreMLRequest(model: model ) {   (request, error ) in
       guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Core ML process failed")
             }
          //  print(results)
            if let fisrtresult = results.first {
                if fisrtresult.identifier.contains("desktop computer"){
                    self.ShowLabel.text = "desktop computer"
                }else{
                    self.ShowLabel.text = "Not computer"
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
           do {
               try handler.perform([request])
           } catch {
               print("Failed to perform classification.\n\(error.localizedDescription)")
           }
    }
}
