//
//  ViewController.swift
//  ToDo
//
//  Created by Marwan Khalawi on 3/2/20.
//  Copyright © 2020 Marwan Khalawi. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {
    var itemArray = ["check mail", "change oil", "Call Mike"]
    
    let userDefault = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = userDefault.value(forKey: "ToDoList") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: - Add Item to ToDo list
    @IBAction func addItemToDo(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "Add a new item to ToDo List", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.userDefault.set(self.itemArray, forKey: "ToDoList")
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

