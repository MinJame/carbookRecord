//
//  CONSUMABLE_DAO.swift
//  pagetest
//
//  Created by min on 2022/07/25.
//

import Foundation
import FMDB
import UIKit


class CONSUMABLE_DAO {
    
    var databaseURL : URL?
    public static let sharedInstance = CARBOOK_DAO()
    
    init() {
        
        let filemgr = FileManager.default
        let dirURL = filemgr.urls(for: Manager_DB.sharedInstance.databasePathDirectory, in: .userDomainMask).first!
        databaseURL = dirURL.appendingPathComponent("Carbook").appendingPathComponent("carbook.db")
    }
    
    func insertConsumableItems(consumableItems : Dictionary<String,Any>) -> Dictionary<String,Any> {
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let date = Date()
            let updateFormatter = DateFormatter()
            let globalDateFormatter = DateFormatter()
            
            updateFormatter.dateFormat = "yyyyMMddHHmmss"
            updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
            globalDateFormatter.dateFormat =  "yyyyMMddHHmmss"
            dateFormatter.locale = Locale(identifier: "ko_KR")
            updateFormatter.locale = Locale(identifier: "ko_KR")
            globalDateFormatter.locale =  Locale(identifier: "ko_KR")
            let insertSQL = "Insert Into CONSUMABLE (carSN, consumableID,consumableKey,consumableCode,consumableIsHidden,consumableDivision,consumableTitle,consumableCycleTerm,consumableCycleDist,consumableRegTime,consumableGlobalTime,consumableUploadTime,consumableUpdateTime) Values('\(consumableItems["carSN"]!)','\(consumableItems[ "consumableID"]!)','\(consumableItems["consumableKey"]!)','\(consumableItems["consumableCode"]!)', '\(consumableItems["consumableIsHidden"]!)', '\(consumableItems["consumableDivision"]!)', '\(consumableItems["consumableTitle"]!)', '\(consumableItems["consumableCycleTerm"]!)','\(consumableItems["consumableCycleDist"]!)','\(dateFormatter.string(from: date))', '\(updateFormatter.string(from: date))', '\(globalDateFormatter.string(from: date))')"
            //
            
            Swift.print("저기는 : \(insertSQL)")
            
            let result = carbookDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                Swift.print("Error \(carbookDB.lastErrorMessage())")
            }
            return ["result" : result]
            
        }
        return ["result" : false]
        }
    }

