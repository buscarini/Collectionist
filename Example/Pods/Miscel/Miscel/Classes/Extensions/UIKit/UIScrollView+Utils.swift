//
//  UIScrollView+Utils.swift
//  Pods
//
//  Created by José Manuel Sánchez Peñarroja on 7/7/16.
//
//

import UIKit

public enum PagingOrientation {
	case horizontal
	case vertical
}

extension UIScrollView {

	static func offset(_ scrollView: UIScrollView, forPage: Int, orientation: PagingOrientation) -> CGFloat {
	
		let page = CGFloat(forPage)
	
		switch orientation {
			case .horizontal:
				return scrollView.bounds.size.width*page
			
			case .vertical:
				return scrollView.bounds.size.height*page
		}
	}

	static func numPages(_ scrollView: UIScrollView, orientation: PagingOrientation) -> Int {
		switch orientation {
			case .horizontal:
				return Int(scrollView.contentSize.width/scrollView.bounds.size.width)
			
			case .vertical:
				return Int(scrollView.contentSize.height/scrollView.bounds.size.height)
		}
	}

	static func currentPage(_ scrollView: UIScrollView, orientation: PagingOrientation) -> Int {
		let offset: CGFloat
		switch orientation {
			case .horizontal:
				offset = scrollView.contentOffset.x
			
			case .vertical:
				offset = scrollView.contentOffset.y
		}
		
		return Int(offset/CGFloat(self.numPages(scrollView, orientation: orientation)))
	}
}

