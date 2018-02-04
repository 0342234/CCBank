//
//  SelectedHistoryController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 04.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit
import CoreData

class SelectedHistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
   
    var searchController = UISearchController()
    var resultsTableView = UITableViewController()
    
    var groupedCurrencies : GroupedCurrencies?
    var rowData: [HundredCCurrencies]!
    var currentData: [CurrenciesModel] = {
        return  DataManager.shared.data
    }()
    
    private var filteredDataSource: [HundredCCurrencies] = []
    
    var hundredObjects : [HundredCCurrencies]?
   
    @IBOutlet weak var tableView: UITableView!
    var cellExpanded = false
    var expandedRows = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var objects = groupedCurrencies?.hundredCurrencies?.allObjects as! [HundredCCurrencies]
        objects.sort { Int($0.rank)! < Int($1.rank)! }
        hundredObjects = objects
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let cellCurrencyCopy = UINib(nibName: "SelectedHistoryCell", bundle: nil)
        self.tableView.register(cellCurrencyCopy, forCellReuseIdentifier: "SelectedHistoryCell")
        self.title = groupedCurrencies?.addingDate.toString(dateFormat: "MMM d, h:mm a") ?? "Undefinded date"
           resultsTableView.tableView.register(cellCurrencyCopy, forCellReuseIdentifier: "SelectedHistoryCell")
        searchController = UISearchController(searchResultsController: resultsTableView)
        searchController.searchResultsUpdater = self
        if var frame = navigationController?.navigationBar.frame {
            frame.size.height += 7
            let view = UIView(frame: frame )
            view.addSubview(searchController.searchBar)
            tableView.tableHeaderView = view //searchController.searchBar
        }
        //tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        
        resultsTableView.tableView.delegate = self
        resultsTableView.tableView.dataSource = self
    }
    func updateSearchResults(for searchController: UISearchController) {
        filteredDataSource = hundredObjects!.filter( { model in
            return model.name.contains(searchController.searchBar.text!)})
        resultsTableView.tableView.reloadData()
    }

    // MARK:  Table View Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == resultsTableView.tableView {
         return filteredDataSource.count
        } else {
        return groupedCurrencies?.hundredCurrencies?.count ?? 0
    }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedHistoryCell", for: indexPath) as? SelectedHistoryCell
        
        if tableView == resultsTableView.tableView {
            rowData = filteredDataSource
        } else {
            rowData = hundredObjects!
        }
        let currencyName = rowData[indexPath.row].name
        let savedCurrencyPrice = rowData[indexPath.row].usdValue
        let currencyCapitalization = rowData[indexPath.row].capitalization  ?? "Undefined"
        
        var currentPrice = "undefined"
        var currentCapitalization = "undefined"
        var priceChanges = "undefined"
        var capitalizationChanges = "undefined"
        
        for i in currentData {
            if i.name == currencyName {
                currentCapitalization = i.available_supply!
                let oldCapValue = Double(currencyCapitalization)
                let currentCapValue = Double(currentCapitalization)
                let capPercentChanges = ( (currentCapValue! - oldCapValue! ) / oldCapValue! ) * 100
                capitalizationChanges = String(format: "%.5f", capPercentChanges)
                
                currentPrice =  i.price_usd
                let currentPriceValue = Double(currentPrice)
                let savedPriceValue = Double(savedCurrencyPrice)
                let pricePercentChanges = ((currentPriceValue! - savedPriceValue!) / savedPriceValue! ) * 100
                priceChanges = String(format: "%.2f", pricePercentChanges)
            }
        }
        
        cell?.setupCell(name: currencyName, savedPrice: savedCurrencyPrice, currentPrice: currentPrice, priceChanges: priceChanges, savedCapitalization: currencyCapitalization, currentCapitalization: currentCapitalization, capitalizationChanges: capitalizationChanges)
        cell?.isExpanded = self.expandedRows.contains(indexPath.row)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectedHistoryCell
            else { return }
        switch cell.isExpanded {
        case true:
            self.expandedRows.remove(indexPath.row)
        case false:
            self.expandedRows.insert(indexPath.row)
        }
        cell.isExpanded = !cell.isExpanded
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        self.resultsTableView.tableView.beginUpdates()
        self.resultsTableView.tableView.endUpdates()
        
    }
}
