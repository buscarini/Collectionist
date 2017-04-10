//
//  VersionNumberView.swift
//  Project
//
//  Created by José Manuel Sánchez Peñarroja on 27/7/16.
//
//

import UIKit

@IBDesignable
class VersionNumberView: UIView {
	let label: UILabel

	required init?(coder aDecoder: NSCoder) {
		self.label = UILabel()
		
		super.init(coder: aDecoder)

		self.label.text = self.version()
		self.addSubview(self.label)
	
		
//		self.label.auto
		
//		self.label.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))

		self.lightMode()
	}
	
	func darkMode() {
		self.label.textColor = UIColor.white
		self.label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
		self.backgroundColor = UIColor.darkGray
		self.layer.cornerRadius = 4
		self.clipsToBounds = true
		self.alpha = 0.85
	}
	
	func lightMode() {
		self.label.textColor = UIColor.black
		self.label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
		self.backgroundColor = UIColor.clear
		self.layer.cornerRadius = 0
		self.clipsToBounds = false
		self.alpha = 1.0
	}

	private func version() -> String {
		let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
		let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
		
		return appVersion.flatMap { version in build.map { build in "v\(version) (\(build))" } } ?? ""
	}
}
