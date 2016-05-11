//
//  CollectionViewController.swift
//  Collectionist
//
//  Created by José Manuel Sánchez Peñarroja on 11/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

import Collectionist

class CollectionViewController: UIViewController {

	@IBOutlet var collectionView : UICollectionView?

	var models: [Model] = Model.exampleModels()
	var dataSource = CollectionViewDataSource<Model>()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.dataSource.view = self.collectionView
		self.collectionView?.delegate = self.dataSource
		
		updateList()
    }

	func updateList() {
		self.dataSource.list = List<Model>.listFrom(self.models, nibName : "ModelView")
	}

}
