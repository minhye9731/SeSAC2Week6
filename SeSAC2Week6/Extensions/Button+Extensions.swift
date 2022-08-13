//
//  Button+Extensions.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/13/22.
//

import Foundation
import UIKit

@available (iOS 15.0, *)
extension UIButton.Configuration {
    
    static func cameraStyle() -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "카메라"
        configuration.subtitle = "여기보세요~ 하나 둘 셋!"
        configuration.titleAlignment = .center
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .systemRed
        configuration.image = UIImage(systemName: "star.fill")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        configuration.cornerStyle = .capsule
        configuration.showsActivityIndicator = true
        return configuration
    }
    
}
