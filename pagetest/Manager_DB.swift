//
//  Manager_DB.swift
//  pagetest
//
//  Created by min on 2022/04/20.
//

import Foundation
import FMDB
import UIKit

class Manager_DB {
    
    
    
    static let dataBaseVersion = 2
    
    var databaseURL : URL?
    var databasePathDirectory = FileManager.SearchPathDirectory.applicationSupportDirectory
    public static let sharedInstance = Manager_DB()
    var databaseCheck : [String:[String:String]] = [:]
    
    let create_REPAIR = "CREATE TABLE REPAIR (_id INTEGER PRIMARY KEY AUTOINCREMENT,carSN INTEGER DEFAULT 0,repairID TEXT,repairKey TEXT, repairIsHidden INTEGER DEFAULT 0,repairMode INTEGER,repairPlace TEXT,repairAddress TEXT,repairLatitude REAL,repairLongitude REAL,repairExpendDate TEXT,repairDist REAL,repairImage TEXT,repairRegTime TEXT,repairUploadTime TEXT,repairUpdateTime TEXT,repairGlobalTime TEXT)"
    
    let create_REPAIRITEM = "CREATE TABLE REPAIRITEM (_id INTEGER PRIMARY KEY AUTOINCREMENT,repairSN INTEGER DEFAULT 0,repairltemID TEXT,repairItemKey TEXT,repairltemIsHidden INTEGER DEFAULT 0,repairltemCategoryCode TEXT,repairItemDivision INTEGER,repairltemName TEXT,repairltemCost REAL DEFAULT 0.0,repairltemMemo TEXT,repairltemRegTime TEXT,repairltemUploadTime TEXT,repairltemUpdateTime TEXT,repairltemGlobalTime TEXT)"
    
    let create_FUELING = "CREATE TABLE FUELING (_id INTEGER PRIMARY KEY AUTOINCREMENT, carSN INTEGER,fuelingID TEXT,fuelingKey TEXT,fuelingIsHidden INTEGER DEFAULT 0,fuelingPlace TEXT,fuelingAddress TEXT,fuelingLatitude REAL,fuelingLongitude REAL,fuelingExpendDate TEXT,fuelingDist REAL, fuelingTotalCost REAL DEFAULT 0.0,fuelType TEXT,fuelingFuelCost REAL DEFAULT 0.0,fuelingItemVolume REAL DEFAULT 0.0,fuelingImage TEXT, fuelingMemo TEXT,fuelingRegTime TEXT,fuelingUploadTime TEXT,fuelingUpdateTime TEXT,fuelingGlobalTime TEXT)"
    
    let create_EXPENDABLE = "CREATE TABLE EXPENDABLE (_id INTEGER PRIMARY KEY AUTOINCREMENT, carSN INTEGER,expendableID TEXT,expendableKey TEXT,expendableIsHidden INTEGER DEFAULT 0,expendablescategoryCode INTEGER DEFAULT 0,expendableDivision INTEGER DEFAULT 0,expendableTitle TEXT,expendableCycleTerm INTEGER,expendableCycleDist REAL,cycleTermExist INTEGER,expendableRegTime TEXT,expendableUploadTime TEXT,expendableUpdateTime TEXT,expendableGlobalTime TEXT)"
    
    
    init() {
        
        let REPAIR_column = ["_id" : "INTEGER PRIMARY KEY AUTOINCREMENT","carSN" : "INTEGER DEFAULT 0","repairID" :"TEXT","repairKey" : "TEXT","repairIsHidden" : "INTEGER DEFAULT 0","repairMode" : "INTEGER","repairPlace" : "TEXT","repairLatitude" : "REAL","repairLongitude" : "REAL","repairExpendDate" : "TEXT","repairDist" : "REAL DEFAULT 0.0","repairImage" :"TEXT","repairRegTime" : "TEXT", "repairUploadTime" : "TEXT","repairUpdateTime" : "TEXT","repairGlobalTime" : "TEXT"]
        
        let REPAIRITEM_column = ["_id" : "INTEGER PRIMARY KEY AUTOINCREMENT","repairSN " : "INTEGER","repairItemID" : "TEXT","repairItemKey":"TEXT","repairItemIsHidden" :"INTEGER DEFAULT 0","repairltemCategoryCode" : "INTEGER","repairItemDivision": "INTEGER","repairltemName" :"TEXT","repairltemCost" : "REAL DEFAULT 0.0","repairltemMemo" : "TEXT","repairltemRegTime" : "TEXT","repairltemUploadTime" : "TEXT","repairltemUpdateTime" : "TEXT","repairltemGlobalTime" : "TEXT"]
        
        let FUELING_column = ["_id" : "INTEGER PRIMARY KEY AUTOINCREMENT","carSN" : "INTEGER DEFAULT 0","fuelingID " : "TEXT","fuelingKey": "TEXT", "fuelingIsHidden" : "INTEGER DEFAULT 0","fuelingPlace": "TEXT","fuelingAddress" : "TEXT","fuelingLatitude" : "REAL DEFAULT 0.0","fuelingLongitude" : "REAL DEFAULT 0.0","fuelingExpendDate" : "TEXT","fuelingDist" : "REAL DEFAULT 0.0","fuelingTotalCost" : "REAL DEFAULT 0.0","fuelType" : "TEXT","fuelingFuelCost" : "REAL DEFAULT 0.0","fuelingItemVolume" : "REAL DEFAULT 0.0","fuelingImage" : "TEXT","fuelingMemo" : "TEXT", "fuelingRegTime" : "TEXT","fuelingUploadTime" : "TEXT","fuelingUpdateTime" : "TEXT","fuelingGlobalTime" : "TEXT"]
        
        let EXPENDALE_column = ["_id" : "INTEGER PRIMARY KEY AUTOINCREMENT","carSN" : "INTEGER DEFAULT 0","expendableID": "TEXT","expendableKey" : "TEXT","expendableIsHidden" : "INTEGER DEFAULT 0", "expendablescategoryCode" : "INTEGER DEFAULT 0","expendableDivision": "INTEGER DEFAULT 0","expendableTitle" : "TEXT","expendableCycleTerm" : "INTEGER DEFAULT 0","expendableCycleDist" : "REAL DEFAULT 0.0","cycleTermExist" : "INTEGER DEFAULT 0","expendableRegTime" : "TEXT","expendableUploadTime" : "TEXT","expendableUpdateTime" : "TEXT","expendableGlobalTime" : "TEXT"]
        
        databaseCheck.updateValue(REPAIR_column, forKey: "REPAIR")
        databaseCheck.updateValue(REPAIRITEM_column, forKey: "REPAIRITEM")
        databaseCheck.updateValue(FUELING_column, forKey: "FUELING")
        databaseCheck.updateValue(EXPENDALE_column, forKey: "EXPENDALE")
        
        Swift.print("db??????")
        let filemangr = FileManager.default
        
        let preDirURL = filemangr.urls(for: .documentDirectory, in: .userDomainMask).first!
        let preDatabaseURL = preDirURL.appendingPathComponent("carbook.db")
        
        let appSupprotURL = filemangr.urls(for : .applicationSupportDirectory, in: .userDomainMask).first!
        
        var directoryURL = appSupprotURL.appendingPathComponent("Carbook")
        
        do {
            try filemangr.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            databaseURL = directoryURL.appendingPathComponent("carbook.db")
            
        
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try? directoryURL.setResourceValues(resourceValues)
            
        }catch{
            print("An erro occured!")
        }
        
        if filemangr.fileExists(atPath: preDatabaseURL.path) {
            do {
                try filemangr.moveItem(atPath: preDatabaseURL.path, toPath: databaseURL!.path)
                print("Move To Successful")
            }catch let error {
                print("Moved failed : \(error)")
                databaseURL = preDatabaseURL
                databasePathDirectory = FileManager.SearchPathDirectory.documentDirectory
            }
        }

        if !filemangr.fileExists(atPath: databaseURL!.path){
            let carbookDB = FMDatabase(path : databaseURL!.path)
            Swift.print("create Tables")
            Swift.print("?????????")
            if carbookDB.open() {
                if !carbookDB.executeStatements(create_REPAIR){
                    Swift.print("??????\(carbookDB.lastErrorMessage())")
                }
                if !carbookDB.executeStatements(create_REPAIRITEM){
                    Swift.print("??????\(carbookDB.lastErrorMessage())")
                }
                if !carbookDB.executeStatements(create_FUELING){
                    Swift.print("??????\(carbookDB.lastErrorMessage())")
                }
                if !carbookDB.executeStatements(create_EXPENDABLE){
                    Swift.print("??????\(carbookDB.lastErrorMessage())")
                }
            }
            var create_sql = ""
            Swift.print("create_sql : \(create_sql)")
            carbookDB.userVersion = UInt32(Manager_DB.dataBaseVersion)
            carbookDB.close()
        }else {
            let carbookDB = FMDatabase(path: databaseURL!.path)
            if carbookDB.open() {
                Swift.print("datBase Version :\(carbookDB.userVersion)")
                if carbookDB.userVersion != Manager_DB.dataBaseVersion {
                    databaseCheck.forEach {(item) in
                        
                        if !(carbookDB.tableExists(item.key)) {
                            var create_sql = ""
                            switch item.key {
                            case "REPAIR" :
                                create_sql = create_REPAIR
                            case "REPAIRITEM" :
                             create_sql = create_REPAIRITEM
                            case "FUELING" :
                             create_sql = create_FUELING
                            case "EXPENDABLE" :
                                create_sql = create_EXPENDABLE
                         default:
                             return
                            }
                            Swift.print("create_sql : \(create_sql)")
                        }
                    }
                }
            }
        }
        
    }
}
