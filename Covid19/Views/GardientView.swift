//
//  GardientView.swift
//  Covid19
//
//  Created by curry敏 on 2021/7/22.
//

import UIKit

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.init(cgColor: #colorLiteral(red: 0.1114327386, green: 0.1781171858, blue: 0.3106700182, alpha: 1)),UIColor.init(cgColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))]
    }
}
