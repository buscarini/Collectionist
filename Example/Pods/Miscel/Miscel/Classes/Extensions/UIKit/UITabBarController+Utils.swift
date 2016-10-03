//
//  UITabBarController+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/6/16.
//
//

import UIKit

extension UITabBarController {
	public func replaceViewControllers(_ viewControllers: [UIViewController], animated: Bool, completion: @escaping () -> ()) {
		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		setViewControllers(viewControllers, animated: animated)
		CATransaction.commit()
	}
}

