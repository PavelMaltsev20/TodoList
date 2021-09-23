//
//  Data.swift
//  TodoList
//
//  Created by Pavel Maltsev on 23/09/2021.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
