//
//  Category.swift
//  ToDo List
//
//  Created by rd on 2/11/18.
//  Copyright © 2018 Richard Dittmyre. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
