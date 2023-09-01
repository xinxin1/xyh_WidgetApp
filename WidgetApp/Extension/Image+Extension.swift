//
//  Image+Extension.swift
//  WidgetApp
//
//  Created by 李昆明 on 2023/8/9.
//

import Foundation

extension UIImage {
    /// 截取图片的指定区域，并生成新图片
    /// - Parameter rect: 指定的区域
    func cropImage(rect: CGRect) -> UIImage? {
        let scale = UIScreen.main.scale
        let x = rect.origin.x * scale
        let y = rect.origin.y * scale
        let width = rect.size.width * scale
        let height = rect.size.height * scale
        let croppingRect = CGRect(x: x, y: y, width: width, height: height)
        // 截取部分图片并生成新图片
        guard let sourceImageRef = self.cgImage else { return nil }
        guard let newImageRef = sourceImageRef.cropping(to: croppingRect) else { return nil }
        let newImage = UIImage(cgImage: newImageRef, scale: scale, orientation: .up)
        return newImage
    }
}
