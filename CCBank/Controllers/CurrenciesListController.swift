//
//  ViewController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 22.12.2017.
//  Copyright © 2017 no-organiztaion-name. All rights reserved.
//

import UIKit
import CoreData

class CurrenciesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl  = UIRefreshControl()
    var searchController = UISearchController()
    var resultsTableView = UITableViewController()
    
    private var dataSource: [CurrenciesModel] { return DataManager.shared.data }
    private var filteredDataSource: [CurrenciesModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        updateCurrenciesTableView()
        tableView.delegate = self
        tableView.dataSource = self
        navigationBarConfigurations()
        
        let _ = Timer.scheduledTimer(withTimeInterval: 35, repeats: true) { _ in
            self.updateCurrenciesTableView()
        }
        
        let customCellXib = UINib(nibName: "CurrenciesListTableViewCell", bundle: nil)
        self.tableView.register(customCellXib, forCellReuseIdentifier: "CurrenciesListTableViewCell")
        resultsTableView.tableView.register(customCellXib, forCellReuseIdentifier: "CurrenciesListTableViewCell")
        
        refreshControl.tintColor = UIColor.brown
        tableView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        
        searchController = UISearchController(searchResultsController: resultsTableView)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.barTintColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
        if var frame = navigationController?.navigationBar.frame {
            frame.size.height += 3
            let view = UIView(frame: frame)
            view.addSubview(searchController.searchBar)
            tableView.tableHeaderView = view //searchController.searchBar
        }
        
        resultsTableView.tableView.delegate = self
        resultsTableView.tableView.dataSource = self
}

@objc func refreshTableView() {
    DataManager.shared.fetchCurrencyUrl(withSorting: true) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

func navigationBarConfigurations() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showSaveAlert))
    
    navigationItem.leftBarButtonItem?.tintColor = UIColor(red: 184/255, green: 250/255, blue: 236/255, alpha: 1)
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateCurrenciesTableView))
    navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 184/255, green: 250/255, blue: 236/255, alpha: 1)
}

@objc func updateCurrenciesTableView() {
    DataManager.shared.fetchCurrencyUrl(withSorting: true) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
   
    if Reachability.isConnectedToNetwork(){
    }else{
        print("Internet Connection not Available!")
         let alertController = UIAlertController(title: "No Internet", message: "Your phone must be connected to innternet to use application,", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

@objc func showSaveAlert() {
    let alert = UIAlertController(title: "SAVE", message: "Do you want to save data?", preferredStyle: UIAlertControllerStyle.alert)
    let actionYes = UIAlertAction(title: "Yes", style: .default) { _ in
        
        let savingDate = NSDate()
        let data: [CurrenciesModel] = DataManager.shared.data
        let groupOfCCurencies = GroupedCurrencies(context: PersistenceService.context)
        for i in data {
            let hundredCurrencies = HundredCCurrencies(context: PersistenceService.context)
            hundredCurrencies.usdValue = i.price_usd
            hundredCurrencies.name = i.name
            hundredCurrencies.rank = i.rank
            hundredCurrencies.capitalization = i.available_supply ?? "Undefined"
            hundredCurrencies.rank = i.rank
            groupOfCCurencies.addToHundredCurrencies(hundredCurrencies)
            
        }
        groupOfCCurencies.addingDate = savingDate
        PersistenceService.saveContext()
    }
    let actionNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
    alert.addAction(actionYes)
    alert.addAction(actionNo)
    
    present(alert, animated: true, completion: nil)
}


// MARK: - Table View Methods

func numberOfSections(in tableView: UITableView) -> Int {
    if tableView == resultsTableView.tableView {
        return 1
    } else {
        return 2
    }
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == resultsTableView.tableView {
        return filteredDataSource.count
    } else {
        if section == 0 {
            return DataManager.shared.favoriteData.count
        } else {
            return DataManager.shared.notFavoriteCurrentData.count
        }
    }
}

func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if tableView == resultsTableView.tableView {
        return 0.0
    } else {
        return 36
    }
}

@objc func something() {
    print("helloy")
}

func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if tableView == resultsTableView.tableView {
        return UIView()
    } else {
    }
    let view = UIView()
    view.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
    let label = UILabel(frame: CGRect(x: 6, y: 6, width: 150, height: 30))
    let action = UIButton(frame: CGRect(x: 55, y: 8, width: 150, height: 36))
    action.addTarget(self, action: #selector(something), for: UIControlEvents.touchUpInside)
    
    if section == 0 {
        label.text = "Favourites"
        label.textColor = UIColor(red: 184/255, green: 250/255, blue: 236/255, alpha: 1)
    } else {
        label.text = "All Currencies"
        label.textColor = UIColor(red: 184/255, green: 250/255, blue: 236/255, alpha: 1)
    }
    view.addSubview(label)
    view.addSubview(action)
    return view
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CurrenciesListTableViewCell", for: indexPath) as? CurrenciesListTableViewCell
    var rowDataSource: CurrenciesModel!
    
    if tableView == resultsTableView.tableView {
        rowDataSource = filteredDataSource[indexPath.row] } else {
        rowDataSource = indexPath.section == 0 ? DataManager.shared.favoriteData[indexPath.row] :  DataManager.shared.notFavoriteCurrentData[indexPath.row]
    }
    let name = rowDataSource.name
    let usdPrice = rowDataSource.price_usd
    let lastUpdate = rowDataSource.last_updated
    let hourChanges = rowDataSource.percent_change_1h ?? "Undefined"
    let dayChanges = rowDataSource.percent_change_24h ?? "Undefined"
    let lastUpdatePrice = lastUpdateTime(lastUpdate)
    
    cell?.cellInitialization(currencyName: name, updateSeconds: lastUpdatePrice.0, updateMinutes: lastUpdatePrice.1, lastPrice: usdPrice, hourChanges: hourChanges, dayChanges: dayChanges)
    return cell!
    
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? CurrenciesListTableViewCell else { return }
    
    let itemName = cell.currencyName.text
    if tableView == resultsTableView.tableView {
        
        let moc = PersistenceService.context
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteCurrencies", in: moc)
        let currency = NSManagedObject(entity: entity!, insertInto: moc)
        currency.setValue(itemName, forKey: "currencies")
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        let alert = UIAlertController(title: "Saved to favorites", message: "\(itemName!) was saved to favorites", preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertActionOk)
        present(alert, animated: true, completion: {
            DispatchQueue.main.async {
                DataManager.shared.fetchCurrencyUrl(withSorting: true, completion: {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        })
        
        
    } else {
        if indexPath.section == 0 {
            let moc = PersistenceService.context
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteCurrencies")
            let result = try? moc.fetch(fetchRequest)
            let resultData = result as! [FavoriteCurrencies]
            for object in resultData {
                if object.currencies ==  itemName {
                    moc.delete(object)
                }
            }
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            let data = DataManager.shared.favoriteData[indexPath.row]
            tableView.beginUpdates()
            DataManager.shared.notFavoriteCurrentData.append(data)
            DataManager.shared.favoriteData.remove(at: indexPath.row)
            let newIndexPath = NSIndexPath(row: 0, section: 1) as IndexPath
            tableView.moveRow(at: indexPath, to: newIndexPath)
            tableView.endUpdates()
        }
        
        if indexPath.section == 1 {
            let moc = PersistenceService.context
            let entity = NSEntityDescription.entity(forEntityName: "FavoriteCurrencies", in: moc)
            let currency = NSManagedObject(entity: entity!, insertInto: moc)
            currency.setValue(itemName, forKey: "currencies")
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            
            let data = DataManager.shared.notFavoriteCurrentData[indexPath.row]
            tableView.beginUpdates()
            let ccurenciesDependency = DataManager.shared.favoriteData.count
            DataManager.shared.favoriteData.append(data)
            DataManager.shared.notFavoriteCurrentData.remove(at: indexPath.row)
            
            let newIndexPath = NSIndexPath(row: ccurenciesDependency , section: 0) as IndexPath
            tableView.moveRow(at: indexPath, to: newIndexPath)
            tableView.endUpdates()
        }
    }
}

func lastUpdateTime(_ sinceReferenceDate: String) -> (String, String) {
    let timeRightNow = Date()
    let updateTime = Date.init(timeIntervalSince1970: Double(sinceReferenceDate)!)
    let components = Calendar.current.dateComponents([.minute, .second] , from: updateTime, to: timeRightNow)
    let displayMinutes = String(components.minute!)
    let displaySeconds = String(components.second!)
    return (displaySeconds, displayMinutes)
}

// MARK:  UISearchResultUpdating

func updateSearchResults(for searchController: UISearchController) {
    filteredDataSource = dataSource.filter( { model in
        return model.name.lowercased().contains(searchController.searchBar.text!.lowercased())})
    resultsTableView.tableView.reloadData()
    
}
}

