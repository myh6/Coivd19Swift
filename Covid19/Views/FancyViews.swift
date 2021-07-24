//
//  FancyViews.swift
//  Covid19
//
//  Created by curry敏 on 2021/7/24.
//

import UIKit

@IBDesignable
class FancyViews: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
}
