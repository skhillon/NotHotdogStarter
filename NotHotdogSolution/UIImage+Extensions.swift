//
//  ImageUtility.swift
//  NotHotdogSolution
//
//  Created by Sarthak Khillon on 2/1/19.
//  Copyright © 2019 Sarthak Khillon. All rights reserved.
//

import UIKit

extension UIImage {
    // From Google's example.
    func base64Encoding() -> String {
        guard var imageData = self.pngData() else {
            return ""
        }
        
        if (imageData.count > 2097152) {
            let oldSize: CGSize = self.size
            let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
            imageData = resizeImage(to: newSize)
        }
        
        return imageData.base64EncodedString(options: .endLineWithCarriageReturn)
    }
    
    private func resizeImage(to imageSize: CGSize) -> Data {
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let resizedImage = newImage!.pngData()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
}
