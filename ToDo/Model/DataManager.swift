//
//  DataManager.swift
//  ToDo
//
//  Created by Marwan Khalawi on 3/4/20.
//  Copyright © 2020 Marwan Khalawi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol DataManagerDelegate {
    func updateTableView()
}

//struct DataManager {
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    
//    func saveItem() {
//        do{
//            try context.save()
//        } catch {
//            print("Error Save Data \(error)")
//        }
//    }
//    
//    func getItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetch data \(error)")
//        }
//    }
//}
