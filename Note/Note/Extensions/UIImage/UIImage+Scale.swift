//
//  UIImage+Scale.swift
//  Note
//
//  Created by 1okmon on 05.02.2023.
//
import Foundation
import UIKit
extension UIImage {
    func applyByWidth(width: CGFloat) -> UIImage? {
        let scaleCoefficient = self.size.width / width
        let newWidth  = self.size.width / scaleCoefficient
        let newHeight = self.size.height / scaleCoefficient
        let rect = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        let newSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
