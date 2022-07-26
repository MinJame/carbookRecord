//
//  FUELING_DAO.swift
//  pagetest
//
//  Created by min on 2022/07/25.
//

import Foundation
import FMDB
import UIKit


class FUELING_DAO {
    
    var databaseURL : URL?
    public static let sharedInstance = CARBOOK_DAO()
    
    init() {
        
        let filemgr = FileManager.default
        let dirURL = filemgr.urls(for: Manager_DB.sharedInstance.databasePathDirectory, in: .userDomainMask).first!
        databaseURL = dirURL.appendingPathComponent("Carbook").appendingPathComponent("carbook.db")
    }
    
    func insertFuelingItems(fuelingItems : Dictionary<String,Any>) -> Dictionary<String,Any> {
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
            let insertSQL = "Insert Into FUELING (carSN, fuelingID,fuelingIsHidden,fuelingPlace,fuelingAddress,fuelingLatitude,fuelingLongitude ,fuelingExpendDate,fuelingDist,fuelingTotalCost,fuelType,fuelingFuelCost,fuelingItemVolume,fuelingImage,fuelingMemo,fuelingRegTime,fuelingUpdateTime,fuelingGlobalTime) Values('\(fuelingItems["carSN"]!)','\(fuelingItems[ "fuelingID"]!)','\(fuelingItems["fuelingIsHidden"]!)','\(fuelingItems["fuelingPlace"]!)', '\(fuelingItems["fuelingAddress"]!)', '\(fuelingItems["fuelingLatitude"]!)', '\(fuelingItems["fuelingLongitude"]!)', '\(fuelingItems["fuelingExpendDate"]!)','\(fuelingItems["fuelingDist"]!)','\(fuelingItems["fuelingTotalCost"]!)','\(fuelingItems["fuelType"]!)','\(fuelingItems["fuelingFuelCost"]!)','\(fuelingItems["fuelingItemVolume"]!)','\(fuelingItems["fuelingImage"]!)','\(fuelingItems["fuelingMemo"]!)','\(dateFormatter.string(from: date))', '\(updateFormatter.string(from: date))', '\(globalDateFormatter.string(from: date))')"
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
    
    func modifyFuelingItem(fuelingItems : Dictionary<String,Any>) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
 
        let updateFormatter = DateFormatter()
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
      
        updateFormatter.locale = Locale(identifier: "ko_KR")
        if carbookDB.open() {
            defer {carbookDB.close()}
    
                    let updateSQL = "UPDATE FUELING SET fuelingID = '\(fuelingItems["fuelingID"]!)',  fuelingIsHidden = '\(fuelingItems["fuelingIsHidden"]!)', fuelingPlace = '\(fuelingItems["fuelingPlace"]!)', fuelingAddress = '\(fuelingItems["fuelingAddress"]!)',fuelingLatitude = '\(fuelingItems["fuelingLatitude"]!)',fuelingLongitude = '\(fuelingItems["fuelingLongitude"]!)',fuelingExpendDate = '\(fuelingItems["fuelingExpendDate"]!)',fuelingDist = '\(fuelingItems["fuelingDist"]!)',fuelingTotalCost = '\(fuelingItems["fuelingTotalCost"]!)',fuelType = '\(fuelingItems["fuelType"]!)',fuelingFuelCost = '\(fuelingItems["fuelingFuelCost"]!)',fuelingItemVolume = '\(fuelingItems["fuelingItemVolume"]!)',fuelingImage = '\(fuelingItems["fuelingImage"]!)',fuelingMemo = '\(fuelingItems["fuelingMemo"]!)', fuelingUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE fuelingID = '\(fuelingItems["fuelingID"]!)'"
        
                    let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
                    
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(updateSQL)")
               
                return true
            }
        Swift.print("Error \(carbookDB.lastErrorMessage())")
        return false
    }

    
    func deletefuelingData(deleteId : String) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let updateSQL = "UPDATE FUELING SET fuelingIsHidden = 1 WHERE fuelingID = '\(deleteId)'"
            let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
            Swift.print("items:\(result)")
            Swift.print("insertSQL1:\(updateSQL)")
            if !result{
                print("Error \(carbookDB.lastErrorMessage())")
                return false
            }else{
                return true
            }
            
        }else{
            print("Error \(carbookDB.lastErrorMessage())")
            return false
        }
    }
    
    
    

    func selectFuelingData(id : String) -> Dictionary<String, Any>?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * FROM FUELING WHERE fuelingID = '\(id)' AND fuelingIsHidden = 0"
            if let result : FMResultSet = carbookDB.executeQuery(selectSQL, withArgumentsIn:  []) {
                var dict : [String:Any] = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                }
                return dict
            }else {
                return nil
            }
        }else {
            print("Error \(carbookDB.lastErrorMessage())")
            return nil
        }
    }
   
    func selectRangefuelingDataList() -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        if carbookDB.open(){

            let querySQL = "SELECT DISTINCT substr(fuelingExpendDate,0,5) as 'year',substr(fuelingExpendDate,5,2) as 'month' FROM FUELING Where fuelingIsHidden = 0 ORDER BY year DESC, month DESC"
       
            print("querySQL :\(querySQL)")
            var dictArray : [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(querySQL, withArgumentsIn: []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    dictArray?.append(dict)
                }
                
                return dictArray
            }else{
                return nil
            }
        }else{
            print("Error \(carbookDB.lastErrorMessage())")
            return nil
        }
    }
    
    func selectRangeyearoilDataList(year : String?) -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            
            let yearSearchQuery = year != nil ? "AND date Like '\(year!)%'" : ""
            
            let querySQL =  "SELECT *,substr(fuelingExpendDate,0,7) as 'date',substr(fuelingExpendDate,0,13) as 'dates' FROM FUELING WHERE fuelingIsHidden = 0 \(yearSearchQuery) ORDER BY fuelingExpendDate DESC "
            print("querySQL :\(querySQL)")
            var dictArray : [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(querySQL, withArgumentsIn: []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["fuelingExpendDate"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "fuelingExpendDate")
                    }
                    Swift.print("items:\(result)")
                    dictArray?.append(dict)
                }
                
                return dictArray
            }else{
                return nil
            }
        }else{
            print("Error \(carbookDB.lastErrorMessage())")
            return nil
        }
    }
    
    func searchOilDataList(name : String) -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            
            let selectSQL = "SELECT *,substr(fuelingExpendDate,0,5) as 'year', substr(fuelingExpendDate,0,7) as 'date',substr(fuelingExpendDate,0,13) as 'dates' FROM FUELING WHERE (fuelingPlace Like '%\(name)%' OR fuelingMemo Like '%\(name)%' OR fuelingAddress Like '%\(name)%')AND fuelingIsHidden = 0 ORDER BY fuelingExpendDate DESC"
          
            print("selectSQL :\(selectSQL)")
            
            var dictArray: [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(selectSQL, withArgumentsIn:  []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["fuelingExpendDate"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "fuelingExpendDate")
                    }
                    dictArray?.append(dict)
                    print("curry :\(dict)")
                }

                return dictArray
            }else {
                return nil
            }
        }else {
          print("Error \(carbookDB.lastErrorMessage())")
            return nil
        }
    }
    
    
}
