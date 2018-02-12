//
//  Item.swift
//  ToDo List
//
//  Created by rd on 2/11/18.
//  Copyright © 2018 Richard Dittmyre. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
