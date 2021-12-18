//
//  EntriesTableViewController.swift
//  JournalApp-1.0
//
//  Created by STEPHENCOFFARO on 12/8/21.
//

import UIKit

class EntriesTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UITabBarDelegate, UITabBarControllerDelegate {
    
    let searchController = UISearchController()
        
    override func viewDidLoad() {
        loadSavedEntries()
        super.viewDidLoad()
        initSearchController()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        searchController.isActive = false
        searchController.searchBar.text = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ModularNavigationViewController {
            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "AddEntry_vc") {
                tabBarController.present(newVC, animated: true)
                searchController.isActive = false
                searchController.searchBar.text = nil
                return false
            }
        }
        return true
    }
    
    var filteredEntries = [JournalEntry]()
    
    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All", "Work", "School", "Relationships", "Finances", "Health", "Goals"]
        searchController.searchBar.delegate = self

    }

    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //WORKED HERE
        self.tabBarController?.delegate = self
        tableView.reloadData()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        print("View Disappeared")
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchController.isActive) {
            return filteredEntries.count
        } else {
        return entries.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath) as! JournalTableViewCell
        
        //let thisEntry: JournalEntry!
        
        var journalEntry = entries[indexPath.row]
        
        if(searchController.isActive) {
            journalEntry = filteredEntries[indexPath.row]
        } else {
            journalEntry = entries[indexPath.row]
        }
        
        
        cell.update(with: journalEntry)
        cell.showsReorderControl = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } 
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
        
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEntryViewController,
              let journalEntry = sourceViewController.journalEntry else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            entries[selectedIndexPath.row] = journalEntry
            tableView.reloadRows (at: [selectedIndexPath], with: .none)
        } else {
        let newIndexPath = IndexPath(row: entries.count, section: 0)
        entries.insert(journalEntry, at: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        viewWillAppear(true)
        }
    }
    
    @IBAction func unwindTo(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? AddEntryViewController,
              let journalEntry = sourceViewController.journalEntry else { return }

        let newIndexPath = IndexPath(row: entries.count, section: 0)
        entries.insert(journalEntry, at: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        viewWillAppear(true)
        }
    
    @IBAction func unwindFromEdit(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind",
              let sourceViewController = segue.source as? ViewEditEntriesTableViewController,
              let journalEntry = sourceViewController.journalEntry else { return }

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            entries[selectedIndexPath.row] = journalEntry
            tableView.reloadRows (at: [selectedIndexPath], with: .none)
        }
    }
    
    @IBSegueAction func editEntry(_ coder: NSCoder, sender: Any?) -> ViewEditEntriesTableViewController? {
        
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            let entryToEdit = entries[indexPath.row]
            return ViewEditEntriesTableViewController(coder: coder, journalEntry: entryToEdit)
        } else {
            return ViewEditEntriesTableViewController(coder: coder, journalEntry: nil)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        let searchText = searchBar.text!

        filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
    }
    
    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All"){
        filteredEntries = entries.filter {
            entry in
            let scopeMatch = (scopeButton == "All" || checkCategory(entry: entry).contains(scopeButton.lowercased()))
            if(searchController.searchBar.text != "") {
                let searchTextMatch = entry.content.lowercased().contains(searchText.lowercased()) || entry.subject.lowercased().contains(searchText.lowercased())

                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
        tableView.reloadData()
    }
}
