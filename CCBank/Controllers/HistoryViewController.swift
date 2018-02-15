//
//  SavedCCurrenciesViewController.swift
//  CCBank
//
//  Created by Yaroslav Bosenko on 02.01.2018.
//  Copyright © 2018 no-organiztaion-name. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var hundredCurrencies: GroupedCurrencies?
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializteFetchResultController()
        fetchedResultController.delegate = self
        let customCellXib = UINib(nibName: "HistoryTableViewCell", bundle: nil)
        self.tableView.register(customCellXib, forCellReuseIdentifier: "HistoryTableViewCell")
        self.navigationController?.navigationBar.tintColor = UIColor(red: 184/255, green: 250/255, blue: 236/255, alpha: 1)
    }
    
    // MARK : - Fetch Result Controller Initialization
    func initializteFetchResultController() {
        let request  = NSFetchRequest<NSFetchRequestResult>(entityName: "GroupedCurrencies")
        let selectedCopySort = NSSortDescriptor(key: "addingDate", ascending: false)
        request.sortDescriptors = [selectedCopySort]
        
        let moc = PersistenceService.context
        fetchedResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    // MARK: - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fetchedResultController.fetchedObjects?.count ?? 0
   
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Saved currencies"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hundredCurrenciesToVC = fetchedResultController.object(at: indexPath) as? GroupedCurrencies
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = nil
        performSegue(withIdentifier: "toSavedCurrencies", sender: hundredCurrenciesToVC)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSavedCurrencies" {
            let controller = segue.destination as! SelectedHistoryController
            controller.groupedCurrencies = sender as! GroupedCurrencies!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let currecies = fetchedResultController.object(at: indexPath) as! GroupedCurrencies
        cell.addingDateLabel.text = currecies.addingDate.toString(dateFormat: "MM/dd/yyyy")
        cell.addingTimeLabel.text = currecies.addingDate.toString(dateFormat: "HH:mm")
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let maanagedObject = fetchedResultController.object(at: indexPath) as! NSManagedObject
            PersistenceService.context.delete(maanagedObject)
            PersistenceService.saveContext()
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}



