//
//  ViewController.swift
//  ToDo
//
//  Created by Marwan Khalawi on 3/2/20.
//  Copyright © 2020 Marwan Khalawi. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class ToDoViewController: SwipTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - Var we need with Core Data
    /*
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     var itemArray = [Item]()
     */
    
    //MARK: - Var we need with Realm
    let realm = try! Realm()
    var itemArray : Results<Item>?
    
    var selectedCategory: ItemCategory? {
        didSet {
            loadItem()
        }
    }
    
    //MARK: - We only use this if we working with UserDefaults or Decoder and Encoder
    let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Itmes.plist")
    
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //retrive data from UserDefault array with a key
//        if let items = userDefault.array(forKey: "ToDoList") as? [Item]{
//            itemArray = items
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedCategory?.name ?? "Item"
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavBar  Controller doesn't exsit")
        }
        
        if let color = selectedCategory?.categoryColor {
            if let navBarColor = UIColor(hexString: color) {
                let navBarAppearance = UINavigationBarAppearance()
                let contrastColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBarAppearance.configureWithOpaqueBackground()
                navBarAppearance.titleTextAttributes = [.foregroundColor: contrastColor]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColor]
                navBarAppearance.backgroundColor = navBarColor
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.barTintColor = navBarColor
                navBar.standardAppearance = navBarAppearance
                navBar.scrollEdgeAppearance = navBarAppearance
                
                self.searchBar.barTintColor = navBarColor
                self.searchBar.backgroundColor = navBarColor
                self.searchBar.searchTextField.textColor = ContrastColorOf(navBarColor, returnFlat: true)
            }
        }
    }
    
    //MARK: - Add Item to ToDo list
    @IBAction func addItemToDo(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "Add a new item to ToDo List", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
        /*
         process of adding new item using Core Data
         
         let newItem = Item(context: self.context)
         newItem.title = textField.text!
         newItem.parentCategory = self.selectedCategory
         
         self.itemArray.append(newItem)
         */
            
        //process of adding a new item using Realm
            if let currectCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currectCategory.items.append(newItem)
                    }
                } catch {
                     print("Error Save Data \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (TF) in
            TF.placeholder = "Create new item"
            textField = TF
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            if let color = UIColor(hexString: self.selectedCategory!.categoryColor)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item added yet"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemArray?[indexPath.row] {
            do {
                try self.realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error update Data \(error)")
            }
            
        }
        
        self.tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Model Manuplation Methods using Core Data
//    func saveItem() {
//        do{
//            try context.save()
//        } catch {
//            print("Error Save Data \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    //MARK: - Save data using Realm
    func saveItem (item data: Item) {
        do{
            try self.realm.write {
                realm.add(data)
            }
        } catch {
            print("Error Save Data \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    //MARK: - Load Data using Core Data
//    func loadItem(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCH %@", selectedCategory!.name!)
//
//        if let safePredicate = predicate {
//         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [safePredicate, categoryPredicate])
//        } else {
//             request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetch data \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    //MARK: - Load Data using Realm
    func loadItem() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title")
        
        self.tableView.reloadData()
    }
    
    //MARK: - Del Data from swipe
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let deletedItem = self.itemArray?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(deletedItem)
                }
            } catch {
                print("Could not remove Item")
            }
        }
    }
    
    
    
    //MARK: - Model Manuplation Methods using Encoder and Decoder
//    func saveItem() {
//        let encoder = PropertyListEncoder()
//        do {
//            let data = try encoder.encode(self.itemArray)
//            try data.write(to: self.path!)
//        } catch {
//            print("error with \(error)")
//        }
//
//        //            self.userDefault.set(self.itemArray, forKey: "ToDoList")
//        self.tableView.reloadData()
//    }
//
//    func getItems() {
//        if let data = try? Data(contentsOf: path!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding data \(error)")
//            }
//        }
//    }
}

//MARK: - Searchbar Delegate Method

/*
 To query Code data you will need the following
    1- Request of type NSFetchRequest<T> = T.fetchRequest()
    2- assign request.predicate = NSPredicate(format: "String that used to query" . text to use for the query) to query the Code data
    3- if you would like to sort the result assign request.sortDescriptors to NSSortDescriptor(key: "string",ascending: Bool) cons
    4- fetch the data and assign the result to the list
 */
extension ToDoViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //preform a search with Core Data
        /*
         let request : NSFetchRequest<Item> = Item.fetchRequest()
         request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
         
         getItems(with: request)
         */
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    //Clear the search, get back original data and hide the keyboard
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
