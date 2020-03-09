//
//  Item.swift
//  ToDo
//
//  Created by Marwan Khalawi on 3/4/20.
//  Copyright © 2020 Marwan Khalawi. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    
    //inverse relationship using linkingObjects
    var parentCategory = LinkingObjects(fromType: ItemCategory.self, property: "items")
}
