//
//  RealmBaseConfigurator.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import Foundation
import CoreData
import RealmSwift

class RealmBaseConfigurator {
    //SET new value
    static let dbVersion: UInt64 = 1
    
    static func configure() {
        
        var config = Realm.Configuration (
            schemaVersion: dbVersion,
            //            migrationBlock: { migration, oldSchemaVersion in
            //
            //        },
            deleteRealmIfMigrationNeeded: true,
            shouldCompactOnLaunch: { totalBytes, usedBytes in
                // totalBytes refers to the size of the file on disk in bytes (data + free space)
                // usedBytes refers to the number of bytes used by data in the file
                
                // Compact if the file is over 100MB in size and less than 50% 'used'
                let oneHundredMB = 100 * 1024 * 1024
                return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        })
        
        config.fileURL = config
            .fileURL?
            .deletingLastPathComponent()
            .appendingPathComponent("githubsearch.realm")
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        Log.debug.log("REALM PATH")
        Log.debug.log(Realm.Configuration.defaultConfiguration.fileURL ?? "")
        Log.debug.log("-----")
        // force change
        _ = try? Realm()
    }
}
