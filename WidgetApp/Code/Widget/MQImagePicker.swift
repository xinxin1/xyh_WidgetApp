//
//  MQImagePicker.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/9.
//

import SwiftUI
import UIKit
import Photos

struct MQImagePicker: UIViewControllerRepresentable {
    var type: Int
    var selectedImageHandller: ((UIImage) -> Void)?
    var selectedSmallImageTypes = [1,2,3,4,5,6, 7, 8, 9, 10, 11]
    var selectedImagesHandller: (([UIImage]) -> Void)?
    
    @Environment(\.presentationMode) private var presentationMode
    
    typealias UIViewControllerType = UIImagePickerController
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MQImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MQImagePicker>) {
        
    }
    
    // private make Coorinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: MQImagePicker
        
        init(_ parent: MQImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Small 1 2 3 4 5 6
                // Medium 7 8 9 上中下
                // Large  10 11  上下
                let rect = getRectWithType(self.parent.type)
                if let selectedImageHandller = parent.selectedImageHandller,
                   let croppedImage = image.cropImage(rect: rect) {
                    selectedImageHandller(croppedImage)
                }
                
                // 所有Small类型6种图片
                var selectedTempImages: [UIImage] = []
                for type in self.parent.selectedSmallImageTypes {
                    // 这里是指定Small type了
                    let smallRect = getRectWithType(type)
                    if let smallImage = image.cropImage(rect: smallRect) {
                        selectedTempImages.append(smallImage)
                    }
                }
                if let selectedImagesHandller = parent.selectedImagesHandller {
                    selectedImagesHandller(selectedTempImages)
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        func getRectWithType(_ type: Int) -> CGRect {
            var rect = CGRect.zero
            var point = CGPoint.zero
            var size = CGSize.zero
            if type == 1  {
                size = MQWidgetSize().getWidgetSize(.small)
                point = MQWidgetSize().getSmallWidgetPosition(.topLeft)
            } else if type == 2  {
                size = MQWidgetSize().getWidgetSize(.small)
                point = MQWidgetSize().getSmallWidgetPosition(.topRight)
            } else if type == 3  {
                size = MQWidgetSize().getWidgetSize(.small)
                point = MQWidgetSize().getSmallWidgetPosition(.middleLeft)
            } else if type == 4  {
                size = MQWidgetSize().getWidgetSize(.small)
                point = MQWidgetSize().getSmallWidgetPosition(.middleRight)
            } else if type == 5  {
                size = MQWidgetSize().getWidgetSize(.small)
                point = MQWidgetSize().getSmallWidgetPosition(.bottomLeft)
            } else if type == 6 {
                size = MQWidgetSize().getWidgetSize(.small)
                point = MQWidgetSize().getSmallWidgetPosition(.bottomRight)
            } else if type == 7  {
                size = MQWidgetSize().getWidgetSize(.medium)
                point = MQWidgetSize().getMiddleWidgetPosition(.top) // getMiddleWidgetPosition
            } else if type == 8  {
                size = MQWidgetSize().getWidgetSize(.medium)
                point = MQWidgetSize().getMiddleWidgetPosition(.middle) // getMiddleWidgetPosition
            } else if type == 9  {
                size = MQWidgetSize().getWidgetSize(.medium)
                point = MQWidgetSize().getMiddleWidgetPosition(.bottom) // getMiddleWidgetPosition
            } else if type == 10  {
                size = MQWidgetSize().getWidgetSize(.large)
                point = MQWidgetSize().getLargeWidgetPosition(.top) // getLargeWidgetPosition
            } else if type == 11  {
                size = MQWidgetSize().getWidgetSize(.large)
                point = MQWidgetSize().getLargeWidgetPosition(.bottom) // getLargeWidgetPosition
            }
            rect = CGRect(x: point.x,
                          y: point.y,
                          width: size.width,
                          height: size.height)
            return rect
            
        }
    }
}
