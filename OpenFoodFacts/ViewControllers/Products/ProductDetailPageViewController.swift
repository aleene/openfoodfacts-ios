//
//  ProductDetailPageViewController.swift
//  OpenFoodFacts
//
//  Created by Andrés Pizá Bückmann on 06/05/2017.
//  Copyright © 2017 Andrés Pizá Bückmann. All rights reserved.
//

import UIKit
import XLPagerTabStrip

// H = Header, R = Row
class ProductDetailPageViewController<H: ConfigurableUITableViewCell<Product>, R: ConfigurableUITableViewCell<InfoRow>>: UIViewController, UITableViewDelegate, UITableViewDataSource, IndicatorInfoProvider {
    lazy var tableView = UITableView()
    var product: Product!
    var infoRows = [InfoRow]()
    var localizedTitle = ""
    
    init(product: Product, localizedTitle: String, infoRowList: [(String?, InfoRowKey)]) {
        super.init(nibName: nil, bundle: nil)
        
        self.product = product
        calculateInfoRows(infoRowList)
        self.localizedTitle = localizedTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        tableView.dataSource = self
        tableView.delegate = self
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: H.identifier, bundle: nil), forCellReuseIdentifier: H.identifier)
        tableView.register(UINib(nibName: R.identifier, bundle: nil), forCellReuseIdentifier: R.identifier)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
    }
    
    fileprivate func calculateInfoRows(_ infoRowList: [(String?, InfoRowKey)]) {
        for (property, label) in infoRowList {
            if let property = property, !property.isEmpty {
                infoRows.append(InfoRow(label: label, value: property))
            }
        }
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        } else {
            return 44
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return infoRows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return createHeaderCell()
        }
        else {
            return createRow(row: indexPath.row)
        }
    }
    
    func createHeaderCell() -> H {
        let cell = tableView.dequeueReusableCell(withIdentifier: H.identifier) as! H
        
        cell.configure(with: product)
        
        return cell
    }
    
    func createRow(row: Int) -> R {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.identifier) as! R
        
        let infoRow = infoRows[row]
        
        cell.configure(with: infoRow)
        
        return cell
    }
    
    // MARK: - Indicator info provider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: localizedTitle)
    }
}