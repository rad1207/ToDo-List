//
//  AppDelegate.swift
//  ToDo List
//
//  Created by rd on 2/5/18.
//  Copyright © 2018 Richard Dittmyre. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // REALM

        do{
            _ = try Realm()
        } catch {
            print("Error initialinzing new realm, \(error)")
        }
 
        return true
    }




}

