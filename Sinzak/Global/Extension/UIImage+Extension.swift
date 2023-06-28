//
//  UIImage+Extension.swift
//  Sinzak
//
//  Created by JongHoon on 2023/06/26.
//

import UIKit

extension UIImage {
    
    func compressImageData(targetMB: Double = 1.0) -> Data? {
        guard var imageSize = self.jpegData(compressionQuality: 0.8)?.count else { return nil }
        let resizeLength = 2048
        var compressedImage: UIImage? = self
        var resizeScale = 1.0
        while Double(imageSize) > targetMB * pow(2, 20) {
            compressedImage = self.resized(toLength: Double(resizeLength) * resizeScale)
            imageSize = compressedImage?.jpegData(compressionQuality: 0.8)?.count ?? 0
            resizeScale *= 0.75
        }

        return compressedImage?.jpegData(compressionQuality: 0.8)
    }
    
    func resized(toLength length: CGFloat) -> UIImage? {
        let canvasSize = size.width > size.height
        ? CGSize(
            width: length,
            height: CGFloat(ceil(length/size.width * size.height))
        )
        : CGSize(
            width: CGFloat(ceil(length/size.height * size.width)),
            height: length
        )
        
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(scale: CGFloat) -> UIImage? {
        let canvasSize = CGSize(
            width: round(self.size.width * scale),
            height: round(self.size.height * scale)
        )
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func resize(scale: CGFloat) -> UIImage {
        let newWidth = round(self.size.width * scale)
        let newHeight = round(self.size.height * scale)
        
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
}
