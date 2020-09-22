//
//  Utils.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 18/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import Foundation
import UIKit

class Utils {
         
    class func createLayers(containerLayer: CALayer, contentLayer: CALayer, cornerRadius: CGFloat) {
        
        containerLayer.cornerRadius = cornerRadius
        containerLayer.masksToBounds = false;
        containerLayer.shouldRasterize = true;
        containerLayer.rasterizationScale = UIScreen.main.scale;
        
        contentLayer.cornerRadius = cornerRadius
        contentLayer.masksToBounds = true;
        contentLayer.shouldRasterize = true;
        contentLayer.rasterizationScale = UIScreen.main.scale;
    }
    
    class func createShadow(containerLayer: CALayer, contentLayer: CALayer, shadowOffset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float) {
        
        containerLayer.shadowColor = UIColor.black.cgColor;
        containerLayer.shadowOffset = shadowOffset
        containerLayer.shadowRadius = shadowRadius;
        containerLayer.shadowOpacity = shadowOpacity;
    }
    
    class func setLetterSpacing(label: UILabel, letterSpacing: CGFloat) {
        
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(letterSpacing), range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
    }
    
    class func setLetterSpacing(button: UIButton, letterSpacing: CGFloat) {
            
        let attributedString = NSMutableAttributedString(string: button.title(for: .normal) ?? "")
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(letterSpacing), range: NSRange(location: 0, length: attributedString.length))
        button.setAttributedTitle(attributedString, for: .normal)
    }
}

