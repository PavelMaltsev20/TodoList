//
//  AppDelegate.swift
//  TodoList
//
//  Created by Pavel Maltsev on 22/09/2021.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        do {
            _ = try Realm()
        } catch  {
            print(error)
        }
        
        return true
    }
}

