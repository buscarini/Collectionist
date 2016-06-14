//
//  ViewController.swift
//  Collectionist
//
//  Created by José Manuel on 05/11/2016.
//  Copyright (c) 2016 José Manuel. All rights reserved.
//

import UIKit

import Collectionist

class ViewController: UIViewController {

	@IBOutlet var tableView : UITableView?

	var models: [Model] = Model.exampleModels()
	var dataSource: TableViewDataSource<Model, EmptyType, EmptyType>?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.dataSource = self.tableView.map {TableViewDataSource<Model, EmptyType, EmptyType>(view: $0) }
//		self.dataSource.view = self.tableView
//		self.tableView?.delegate = self.dataSource
		
		updateList()
    }

	func updateList() {
		self.dataSource?.list = Collectionist.List<Model>.listFrom(self.models, nibName : "ModelView")
	}

}

