//
//  Result.swift
//  NotHotdogSolution
//
//  Created by Sarthak Khillon on 2/1/19.
//  Copyright © 2019 Sarthak Khillon. All rights reserved.
//

import UIKit

/// The "Model", where we store each Image's results.
class Result {
    let image: UIImage
    let title: String
    let isHotdog: Bool
    let formattedDate: String
    
    init(image: UIImage, title: String, date: Date, isHotdog: Bool) {
        self.image = image
        self.title = title
        self.isHotdog = isHotdog
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        
        self.formattedDate = formatter.string(from: date)
    }
}
