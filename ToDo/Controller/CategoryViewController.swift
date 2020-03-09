//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Marwan Khalawi on 3/4/20.
//  Copyright © 2020 Marwan Khalawi. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipTableViewController {
    let realm = try! Realm()
    var categoryArray : Results<ItemCategory>?
    
    // We need context for Core Data
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Nav bar is not exsit yet")}
        
        let navBarAppearance = UINavigationBarAppearance()
        let contrastColor = ContrastColorOf(.systemBackground, returnFlat: true)
        
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: contrastColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColor]
        navBarAppearance.backgroundColor = .systemBackground
        navBar.tintColor = ContrastColorOf(.systemBackground, returnFlat: true)
        navBar.barTintColor = .systemBackground
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
        
        
    }

    //MARK: - Add new category
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "Add a new category", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //let newCategory = ItemCategory(context: self.context)    <-- Used with Core Data
            
            let newCategory = ItemCategory()
            newCategory.name = textField.text!
            newCategory.categoryColor = RandomFlatColor().hexValue()
            //self.saveCategory()   <-- Used with Core Data
            
            self.savaCatefory(category: newCategory)
        }
        
        alert.addTextField { (TF) in
            TF.placeholder = "Create new item"
            textField = TF
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipluation Methods
    
    //MARK: - Load Data with Core Data
//    func loadCategory(with request:NSFetchRequest<ItemCategory> = ItemCategory.fetchRequest()) {
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetch data \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    //MARK: - Load Data with Realm
    func loadCategory(){
        categoryArray = realm.objects(ItemCategory.self)
        
        self.tableView.reloadData()
    }
    
    //MARK: - Sava Data with Core Data
//    func saveCategory() {
//        do{
//            try context.save()
//        } catch {
//            print("Error Save Data \(error)")
//        }
//        self.tableView.reloadData()
//    }
    
    //MARK: - Sava Data with Realm
    func savaCatefory (category data: ItemCategory){
        do{
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error Save Data \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Del Data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let deletedCategory = self.categoryArray?[indexPath.row]{
            do {
                try self.realm.write{
                    self.realm.delete(deletedCategory)
                }
            } catch {
                print("Could not remove category")
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categoryArray?[indexPath.row]
        let cellColor = category?.categoryColor ?? "278AFD"
        
        cell.textLabel?.text = category?.name ?? "No Category Added Yet"
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: cellColor)!, returnFlat: true)
        cell.backgroundColor = UIColor(hexString: cellColor)
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemVC = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            itemVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    

}
