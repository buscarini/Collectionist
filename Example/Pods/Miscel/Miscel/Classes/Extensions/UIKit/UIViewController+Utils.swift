//
//  UIViewController+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 16/6/16.
//
//

import UIKit

import Layitout

extension UIViewController {
	public func embed(_ child: UIViewController, inView: UIView) -> UIViewController {
		return self.embed(child) {
			child.view.translatesAutoresizingMaskIntoConstraints = false
			inView.addSubview(child.view)
			Layout.fill(container: inView, view: child.view)
			inView.bringSubview(toFront: child.view)
		}
	}

	public func embed(_ child: UIViewController, addSubview: ()->()) -> UIViewController {
		self.addChildViewController(child)
		addSubview()
		child.didMove(toParentViewController: self)
		return child
	}
	
	public func unembed(_ child: UIViewController) {
		child.willMove(toParentViewController: self)
		child.view.removeFromSuperview()
		child.removeFromParentViewController()
	}
	
	public func removeChildViewControllers() {
		for child in childViewControllers {
			self.unembed(child)
        }
	}
}

