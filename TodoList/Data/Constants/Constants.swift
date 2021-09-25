//
//  Constants.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import Foundation

struct K {
    static let defaultTaskName = "New task created"
    static let defaultCategoryName = "New category created"
    static let cell = "Cell"

    struct Segue{
        static let openTasksView = "openTasksView"
    }
    
    struct Predict {
        static let searchByTitle = "title CONTAINS[cd] %@"
    }
}
