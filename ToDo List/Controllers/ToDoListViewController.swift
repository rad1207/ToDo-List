//
//  ViewController.swift
//  ToDo List
//
//  Created by rd on 2/5/18.
//  Copyright © 2018 Richard Dittmyre. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // certain that you have a value for the selected category
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Swift Ternary Operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row]) // removes the data from permanent storage
//        itemArray.remove(at: indexPath.row) // removes current item from the array which loads the data source
        
        
        //if it is true, it becomes false, if it is false, it becomes true
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
    
        // removes highlight
        tableView.deselectRow(at: indexPath, animated: true)
 
    }

    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item on the UIAlert
          
            //Create a new object of type Item. of the MSManagedObject (rows inside table)
            let newItem = Item(context: self.context)
            newItem.title = textField.text! //attribute
            newItem.done = false // attribute
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
         
        }
        
        //add textfield box on alert message
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Model Manipulation Methods
    
    func saveItems() {
        do {
            try context.save() // commits changes
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // Reading items
    // Both parameters have a default item.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // optional binding - making sure you never unwrap a nil value
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: -  Search Bar Methods
//extends the ToDoListViewController class to add additional delegates
extension ToDoListViewController: UISearchBarDelegate {
    
    // Search item function - must add delegate to class
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
        // sort
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    
    }
    
    // only triggers when text has changed or erased - reverts back to original list.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async { // runs on the main queue in the foreground
                searchBar.resignFirstResponder() // cursor and keyboard should go away
            }
            
        }
    }
}

