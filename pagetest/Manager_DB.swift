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
    
    let create_CARBOOKRECORD = "CREATE TABLE CARBOOKRECORD (_id INTEGER PRIMARY KEY AUTOINCREMENT,carbookRecordRepairMode INTEGER DEFAULT 0,carbookRecordExpendDate TEXT,carbookRecordIsHidden INTEGER DEFAULT 0,carbookRecordTotalDistance REAL DEFAULT 0.0,carbookRecordRegTime TEXT,carbookRecordUpdateTime TEXT)"
    
    let create_CARBOOKRECORDITEM = "CREATE TABLE CARBOOKRECORDITEM (_id INTEGER PRIMARY KEY AUTOINCREMENT,carbookRecordId INTEGER,carbookRecordItemCategoryCode TEXT,carbookRecordItemCategoryName TEXT,carbookRecordItemExpenseMemo TEXT,carbookRecordItemExpenseCost REAL DEFAULT 0.0,carbookRecordItemIsHidden INTEGER DEFAULT 0,carbookRecordItemRegTime TEXT,carbookRecordItemUpdateTime TEXT,carbookRecordOilItem TEXT, carbookRecordOilItemExpenseCost REAL DEFAULT 0.0,carbookRecordOilItemFillFuel TEXT,carbookRecordOilItemFuelLIter REAL DEFAULT 0.0,carbookRecordOilItemExpenseMemo TEXT )"
    
    
    init() {
        
        let CARBOOKRECORD_column = ["_id" : "INTEGER PRIMARY KEY AUTOINCREMENT","carbookRecordRepairMode" : "INTEGER DEFAULT 0","carbookRecordExpendDate" :"TEXT","carbookRecordIsHidden" : "INTEGER DEFAULT 0","carbookRecordTotalDistance" : "REAL DEFAULT 0.0","carbookRecordRegTime" : "TEXT", "carbookRecordUpdateTime" : "TEXT"]
        
        let CARBOOKRECORDITEM_column = ["_id" : "INTEGER PRIMARY KEY AUTOINCREMENT","carbookRecordId " : "INTEGER","carbookRecordItemCategoryCode" : "TEXT","carbookRecordItemCategoryName" :"TEXT","carbookRecordItemExpenseMemo" : "TEXT","carbookRecordItemExpenseCost" : "REAL DEFAULT 0.0","carbookRecordItemIsHidden" : "INTEGER DEFAULT 0", "carbookRecordItemRegTime" : "TEXT","carbookRecordUpdateTime" : "TEXT","carbookRecordOilItem": "TEXT", "carbookRecordOilItemExpenseCost" : "REAL DEFAULT 0.0","carbookRecordOilItemFillFuel": "TEXT","carbookRecordOilItemExpenseMemo" : "TEXT","carbookRecordOilItemFuelLiter" : "REAL DEFAULT 0.0"] 
        
        databaseCheck.updateValue(CARBOOKRECORD_column, forKey: "CARBOOKRECORD")
        databaseCheck.updateValue(CARBOOKRECORDITEM_column, forKey: "CARBOOKRECORDITEM")
        
        Swift.print("db호출")
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
            Swift.print("해볼까")
            if carbookDB.open() {
                if !carbookDB.executeStatements(create_CARBOOKRECORD){
                    Swift.print("에러\(carbookDB.lastErrorMessage())")
                }
                if !carbookDB.executeStatements(create_CARBOOKRECORDITEM){
                    Swift.print("에러\(carbookDB.lastErrorMessage())")
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
                            case "CARBOOKRECORD" :
                                create_sql = create_CARBOOKRECORD
                            case "CARBOOKRECORDITEM" :
                             create_sql = create_CARBOOKRECORDITEM
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
