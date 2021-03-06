//
//  UINib+Utils.swift
//  Miscel
//
//  Created by Jose Manuel Sánchez Peñarroja on 30/10/15.
//  Copyright © 2015 vitaminew. All rights reserved.
//

import UIKit

extension UINib {
	public static func loadNib(_ owner: AnyObject, nibName: String, bundle: Bundle? = nil) -> UIView? {
		guard nibName.characters.count > 0 else { return nil }
	
		return UINib(nibName: nibName, bundle: bundle).instantiate(withOwner: owner, options: nil).first as? UIView
	}
}

