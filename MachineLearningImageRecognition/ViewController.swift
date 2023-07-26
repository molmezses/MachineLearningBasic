//
//  ViewController.swift
//  MachineLearningImageRecognition
//
//  Created by Mustafa Ölmezses on 6.07.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    
    var chosenImage = CIImage()
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeButtonClicked(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true , completion: nil)
        
        if let ciImage = CIImage(image: imageView.image!){
            chosenImage = ciImage
        }
        
        recognizeImage(image: chosenImage)
        
    }
    
    func recognizeImage(image: CIImage){
        
        // 1 Request   istek oluşturma
        // 2 handler   ele alma
        
        
        
        if let model = try?  VNCoreMLModel(for: MobileNetV2().model){
            let request = VNCoreMLRequest(model: model) { vnrequest, error in
                
                if let results = vnrequest.results as? [VNClassificationObservation]{
                    
                    if results.count > 0 {
                        
                        let topResult = results.first
                        
                        DispatchQueue.main.async{
                            
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100 // 0 ila 1 arasında bir sayıyı 100 de göstermek için 100 ile çaprıyoruz
                            let rounded = Int(confidenceLevel * 100) / 100
 
                            self.resultLabel.text  = "\(rounded)% it's \(topResult!.identifier)"
                        }
                        
                    }
                    
                }
                
            }
            
            
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do{
                    try handler.perform([request])
                }catch{
                    print("error")
                }
            }
            
            
            
        }
        
    }
    
    

}

