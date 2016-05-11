//
//  ModelView.swift
//  Collectionist
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

import Collectionist

class ModelView: UIView {

	@IBOutlet var nameLabel : UILabel?
	@IBOutlet var textLabel : UILabel?

}

extension ModelView: Fillable {
	func fill(item: Any?) {
		guard let model = item as? Model else { return }
		
		self.nameLabel?.text = model.name
		self.textLabel?.text = model.text
	}
}
