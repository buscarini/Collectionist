//
//  UIActivityIndicatorView+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 1/7/16.
//
//

import UIKit

extension UIActivityIndicatorView {
	var spinning: Bool {
		get {
			return self.isAnimating
		}
		set(newValue) {
			if newValue {
				self.startAnimating()
			}
			else {
				self.stopAnimating()
			}
		}
	}
}

