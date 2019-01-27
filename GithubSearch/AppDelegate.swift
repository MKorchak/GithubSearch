//
//  AppDelegate.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/26/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RealmBaseConfigurator.configure()
        
        return true
    }

}

