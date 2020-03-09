//
//  ItemCategory.swift
//  ToDo
//
//  Created by Marwan Khalawi on 3/4/20.
//  Copyright © 2020 Marwan Khalawi. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class ItemCategory: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var categoryColor : String = ""
    
    //this is creatign a relationship with Item class
    let items = List<Item>()
}
