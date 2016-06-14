//
//  UITabBarController+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 11/6/16.
//
//

import UIKit

extension UITabBarController {
	public func replaceViewControllers(viewControllers: [UIViewController], animated: Bool, completion: () -> ()) {
		CATransaction.begin()
		CATransaction.setCompletionBlock(completion)
		setViewControllers(viewControllers, animated: animated)
		CATransaction.commit()
	}
}

