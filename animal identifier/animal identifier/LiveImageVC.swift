//
//  LiveImageVC.swift
//  animal identifier
//
//  Created by Jash Balar on 08/06/24.
//

import UIKit

class LiveImageVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func convertToJPGAndPrintPath(image: UIImage) -> (UIImage, String?) {
        if let jpgData = image.jpegData(compressionQuality: 1.0) {
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let jpgFileURL = documentsDirectory.appendingPathComponent("output.jpg")
                
                do {
                    try jpgData.write(to: jpgFileURL)
                    print("JPG image saved at: \(jpgFileURL.path)")
                    if let jpgImage = UIImage(contentsOfFile: jpgFileURL.path) {
                        return (jpgImage, jpgFileURL.path)
                    }
                } catch {
                    print("Error saving JPG image: \(error.localizedDescription)")
                }
            }
        }
        return (image, nil)
    }
    
    @IBAction func btnDone(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // Set the source type to open the photo library
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension LiveImageVC: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            let (jpgImage, jpgPath) = convertToJPGAndPrintPath(image: editedImage)
            self.imageView.image = jpgImage
            print(jpgPath!)
            // You can use jpgImage (JPG format) and jpgPath (path to the saved JPG file) as needed.
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
