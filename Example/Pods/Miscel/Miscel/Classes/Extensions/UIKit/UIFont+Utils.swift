//
//  UIFont.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

public extension UIFont {
    public var monospacedDigitFont: UIFont {
        let fontDescriptorFeatureSettings = [[UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptorFeatureSettingsAttribute: fontDescriptorFeatureSettings]
        let oldFontDescriptor = fontDescriptor
        let newFontDescriptor = oldFontDescriptor.addingAttributes(fontDescriptorAttributes)

        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
	
	public static func fontSize(_ toFit: CGRect, string: String, font: UIFont) -> CGFloat {
		var thefont = font
		
		while !self.fits(toFit, string: string, font: thefont) {
			thefont = thefont.withSize(thefont.pointSize-1)
		}
		
		return thefont.pointSize
	}
	
	public static func fits(_ rect: CGRect, string: String, font: UIFont) -> Bool {
		let nsstring = string as NSString
		
		let maxSize = CGSize(width: rect.width, height: 1000)

		let rect = nsstring.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [ NSFontAttributeName : font ], context: nil)
		return rect.width <= rect.width && rect.height <= rect.height
	}
}
