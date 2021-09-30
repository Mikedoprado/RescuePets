//
//  ImagePicker.swift
//  RescuePets
//
//  Created by Michael do Prado on 6/17/21.

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var selectedImage: UIImage?
//    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.editedImage] as? UIImage {
                if let compressImage = image.jpegData(compressionQuality: 0.8){
                    guard let newImage = UIImage(data: compressImage) else {return}
                    parent.selectedImage = newImage
                }
            }
            
            picker.dismiss(animated: true)
        }
        deinit{
            print("deinit imagePicker")
//            self.parent.selectedImage = nil
        }
    }
    
}
