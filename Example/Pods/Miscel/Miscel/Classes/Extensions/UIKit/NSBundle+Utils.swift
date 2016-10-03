//
//  NSBundle+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 14/6/16.
//
//

import UIKit

extension Bundle {

	public static func loadView(_ nibName: String?, owner: AnyObject) -> UIView? {
		return Bundle.main.loadView(nibName, owner: owner)
	}

	public func loadView(_ nibName : String?, owner: AnyObject) -> UIView? {
		guard let nibName = nibName else {
			return nil
		}
		
		let views = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)
		return views?.first as? UIView
	}
	
	var releaseVersionNumber: String? {
		return self.infoDictionary?["CFBundleShortVersionString"] as? String
	}

	var buildVersionNumber: String? {
		return self.infoDictionary?["CFBundleVersion"] as? String
	}
}

