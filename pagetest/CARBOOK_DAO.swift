//
//  CARBOOK_DAO.swift
//  pagetest
//
//  Created by min on 2022/04/20.
//

import Foundation
import FMDB
import UIKit


class CARBOOK_DAO { 
    
    var databaseURL : URL?
    public static let sharedInstance = CARBOOK_DAO()
    
    init() {
        
        let filemgr = FileManager.default
        let dirURL = filemgr.urls(for: Manager_DB.sharedInstance.databasePathDirectory, in: .userDomainMask).first!
        databaseURL = dirURL.appendingPathComponent("Carbook").appendingPathComponent("carbook.db")
    }
    
    func insertCarbookData(carbookData : Dictionary<String, Any>) -> Dictionary<String, Any> {
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let date = Date()
            let regDateFormmatter = DateFormatter()
            let updateFormatter = DateFormatter()
            let globalDateFormatter = DateFormatter()
            regDateFormmatter.dateFormat = "yyyyMMddHHmmss"
            updateFormatter.dateFormat = "yyyyMMddHHmmss"
            globalDateFormatter.dateFormat =  "yyyyMMddHHmmss"
            updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
            
            
            dateFormatter.locale = Locale(identifier: "ko_KR")
            regDateFormmatter.locale = Locale(identifier: "ko_KR")
            updateFormatter.locale = Locale(identifier: "ko_KR")
            globalDateFormatter.locale =  Locale(identifier: "ko_KR")
            let insertSQL = "Insert Into REPAIR ( carSN,repairID,repairIsHidden,repairMode,repairPlace,repairAddress,repairLatitude,repairLongitude,repairExpendDate,repairDist,repairImage,repairRegTime,repairUpdateTime,repairGlobalTime) Values('\(carbookData["carSN"]!)','\(dateFormatter.string(from:date))','\(carbookData["repairIsHidden"]!)','\(carbookData["repairMode"]!)','\(carbookData["repairPlace"]!)','\(carbookData["repairAddress"]!)','\(carbookData["repairLatitude"]!)','\(carbookData["repairLongitude"]!)','\(carbookData["repairExpendDate"]!)','\(carbookData["repairDist"]!)','\(carbookData["repairImage"]!)','\(regDateFormmatter.string(from: date))','\(updateFormatter.string(from: date))','\(globalDateFormatter.string(from: date))')"
            
            Swift.print("저기는 : \(insertSQL)")
            
            let result = carbookDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                Swift.print("Error1 \(carbookDB.lastErrorMessage())")
            }else {
                let checkSQL = "select last_insert_rowid() as  'id'"
                if let result = carbookDB.executeQuery(checkSQL, withArgumentsIn: []){
                    var id = 0
                    while result.next() {
                        id = Int(result.int(forColumn : "id"))
        
                    }
                    return["result" : true, "id" : id]
                }
            }
            Swift.print("result\(result)")
            return ["result" : result]
            
        }
        return ["result" : false]
    }
    
    
    
    func insertCarbookItems (carbookDataItems :[Dictionary<String,Any>]) -> [Dictionary<String,Any>] {
        
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = Date()
        let regDateFormmatter = DateFormatter()
        let updateFormatter = DateFormatter()
        let globalDateFormatter = DateFormatter()
        regDateFormmatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        globalDateFormatter.dateFormat =  "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        regDateFormmatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        globalDateFormatter.locale =  Locale(identifier: "ko_KR")
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {
                
                carbookDataItems.forEach{ (item) in
                    let insertSQL = "Insert Into REPAIRITEM (repairSN, repairltemID,repairltemIsHidden,repairltemCategoryCode,repairItemDivision,repairltemName,repairltemCost,repairltemMemo,repairltemRegTime,repairltemUpdateTime,repairltemGlobalTime) Values('\(item["repairSN"]!)','\(item["repairItemID"]!)','\(item["repairltemIsHidden"]!)','\(item[ "repairltemCategoryCode"]!)','\(item["repairItemDivision"]!)', '\(item["repairltemName"]!)','\(item["repairltemCost"]!)','\(item["repairltemMemo"]!)','\(regDateFormmatter.string(from: date))','\(updateFormatter.string(from: date))', '\(globalDateFormatter.string(from: date))')"
                    
                    let result = carbookDB.executeUpdate(insertSQL, withArgumentsIn: [])
                    
                    Swift.print("item:\(result)")
                    Swift.print("insertSQL:\(insertSQL)")
                }
                carbookDB.commit()
                return [["result" : true]]
            }
        }
        Swift.print("Error2 \(carbookDB.lastErrorMessage())")
        return [["result" : false]]
    }
    
    func insertCarbookOilItems(carbookDataOilItems : Dictionary<String,Any>) -> Dictionary<String,Any> {
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
            let insertSQL = "Insert Into FUELING (carSN, fuelingID,fuelingISHidden,fuelingPlace,fuelingAddress,fuelingLatitude,fuelingLongitude ,fuelingExpendDate,fuelingDist,fuelingTotalCost,fuelType,fuelingFuelCost,fuelingItemVolume,fuelingImage,fuelingMemo,fuelingRegTime,fuelingUpdateTime,fuelingGlobalTime) Values('\(carbookDataOilItems["carSN"]!)','\(carbookDataOilItems[ "fuelingID"]!)','\(carbookDataOilItems["fuelingISHidden"]!)','\(carbookDataOilItems["fuelingPlace"]!)', '\(carbookDataOilItems["fuelingAddress"]!)', '\(carbookDataOilItems["fuelingLatitude"]!)', '\(carbookDataOilItems["fuelingLongitude"]!)', '\(carbookDataOilItems["fuelingExpendDate"]!)','\(carbookDataOilItems["fuelingDist"]!)','\(carbookDataOilItems["fuelingTotalCost"]!)','\(carbookDataOilItems["fuelType"]!)','\(carbookDataOilItems["fuelingFuelCost"]!)','\(carbookDataOilItems["fuelingItemVolume"]!)','\(carbookDataOilItems["fuelingImage"]!)','\(carbookDataOilItems["fuelingMemo"]!)','\(dateFormatter.string(from: date))', '\(updateFormatter.string(from: date))', '\(globalDateFormatter.string(from: date))')"
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
    
    
    func modifyCarBookData(carbookData :Dictionary<String, Any>, id : String) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        let uploadDateFormmatter = DateFormatter()
        let updateFormatter = DateFormatter()
        
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        uploadDateFormmatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        uploadDateFormmatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let updateSQL = "UPDATE REPAIR SET repairIsHidden = '\(carbookData["repairIsHidden"]!)',repairMode = '\(carbookData["repairMode"]!)', repairPlace = '\(carbookData["repairPlace"]!)', repairAddress = '\(carbookData["repairAddress"]!)', repairLatitude = '\(carbookData["repairLatitude"]!)', repairLongitude = '\(carbookData["repairLongitude"]!)',repairExpendDate = '\(carbookData["repairExpendDate"]!)',repairDist = '\(carbookData["repairDist"]!)',repairImage = '\(carbookData["repairImage"]!)',repairUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE _id = '\(id)' "
            
            let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
            Swift.print("insertSQL1:\(updateSQL)")
            if !result{
                print("Error33 \(carbookDB.lastErrorMessage())")
                return false
            }else{
                return true
            }
            
        }else{
            print("Error44 \(carbookDB.lastErrorMessage())")
            return false
        }
    }
 
    
    func modifyCarBookDataItem(carbookDataItem : [Dictionary<String,Any>]) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let updateFormatter = DateFormatter()
        let uploadDateFormmatter = DateFormatter()
        uploadDateFormmatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        uploadDateFormmatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {
                carbookDataItem.forEach{ (item) in
                    let updateSQL = "UPDATE REPAIRITEM SET repairSN = '\(item["repairSN"]!)',  repairltemIsHidden = '\(item["repairltemIsHidden"]!)', repairltemCategoryCode = '\(item["repairltemCategoryCode"]!)', repairItemDivision = '\(item["repairItemDivision"]!)', repairltemName = '\(item["repairltemName"]!)',repairltemCost = '\(item["repairltemCost"]!)',repairltemMemo = '\(item["repairltemMemo"]!)', repairltemUploadTime = '\(uploadDateFormmatter.string(from: Date()))', repairltemUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE repairSN = '\(item["repairSN"]!)' AND _id = '\(item["_id"]!)' "
        
                    let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
                    
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(updateSQL)")
                }
                carbookDB.commit()
                return true
            }
        }
        Swift.print("Error \(carbookDB.lastErrorMessage())")
        return false
    }
    
    
    
    func modifyCarBookDataOilItem(carbookDataOilItem : Dictionary<String,Any>) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
 
        let updateFormatter = DateFormatter()
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
      
        updateFormatter.locale = Locale(identifier: "ko_KR")
        if carbookDB.open() {
            defer {carbookDB.close()}
    
                    let updateSQL = "UPDATE FUELING SET fuelingID = '\(carbookDataOilItem["fuelingID"]!)',  fuelingISHidden = '\(carbookDataOilItem["fuelingISHidden"]!)', fuelingPlace = '\(carbookDataOilItem["fuelingPlace"]!)', fuelingAddress = '\(carbookDataOilItem["fuelingAddress"]!)',fuelingLatitude = '\(carbookDataOilItem["fuelingLatitude"]!)',fuelingLongitude = '\(carbookDataOilItem["fuelingLongitude"]!)',fuelingExpendDate = '\(carbookDataOilItem["fuelingExpendDate"]!)',fuelingDist = '\(carbookDataOilItem["fuelingDist"]!)',fuelingTotalCost = '\(carbookDataOilItem["fuelingTotalCost"]!)',fuelingFuelCost = '\(carbookDataOilItem["fuelingFuelCost"]!)',fuelingItemVolume = '\(carbookDataOilItem["fuelingItemVolume"]!)',fuelingImage = '\(carbookDataOilItem["fuelingImage"]!)',fuelingMemo = '\(carbookDataOilItem["fuelingMemo"]!)', fuelingUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE fuelingID = '\(carbookDataOilItem["fuelingID"]!)'"
        
                    let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
                    
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(updateSQL)")
               
                return true
            }
        Swift.print("Error \(carbookDB.lastErrorMessage())")
        return false
    }
    
    func deleteCarBookData(deleteId : Int) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let updateSQL = "UPDATE REPAIR SET repairIsHidden = 1 WHERE _id = '\(deleteId)'"
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
    
    
    
    func deleteCarBookDataItem(deleteIds : [Int]) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
  
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {
                deleteIds.forEach{ (item) in
                    let updateSQL = "UPDATE REPAIRITEM SET repairltemIsHidden = 1 WHERE _id = '\(item)'"
        
                    let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
                    
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(updateSQL)")
                }
                carbookDB.commit()
                return true
            }
        }
        Swift.print("Error \(carbookDB.lastErrorMessage())")
        return false
    }
    
    
    func selectCarbookData(id : String) -> Dictionary<String, Any>?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * FROM REPAIR WHERE _id = '\(id)' AND  repairIsHidden = 0"
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
    func selectFuelingData(id : String) -> Dictionary<String, Any>?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * FROM FUELING WHERE fuelingID = '\(id)' AND fuelingISHidden = 0"
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
    
    
    
    func selectCarbookDataList(id : String) -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * FROM REPAIRITEM WHERE repairSN ='\(id)' AND repairltemIsHidden = 0 ORDER BY repairltemUpdateTime DESC"
            var dictArray: [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(selectSQL, withArgumentsIn:  []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    dictArray?.append(dict)
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
    
    func selectRangeCarBookDataList() -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        if carbookDB.open(){

            let querySQL = "SELECT DISTINCT substr(repairExpendDate,0,5) as 'year',substr(repairExpendDate,5,2) as 'month' FROM REPAIR Where repairIsHidden = 0 ORDER BY year DESC, month DESC"
       
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
    
    func selectRangefuelingDataList() -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        if carbookDB.open(){

            let querySQL = "SELECT DISTINCT substr(fuelingExpendDate,0,5) as 'year',substr(fuelingExpendDate,5,2) as 'month' FROM FUELING Where fuelingISHidden = 0 ORDER BY year DESC, month DESC"
       
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
    
    func selectRangeyearCarBookDataList(year : String?) -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        if carbookDB.open(){
            
            let yearSearchQuery = year != nil ? "WHERE date Like '\(year!)%'" : ""
            
            let querySQL =  "SELECT * , substr(repairExpendDate,0,7) as 'date' FROM REPAIR as 'A' JOIN(SELECT repairSN,repairltemID,repairItemKey,repairltemIsHidden,repairltemCategoryCode,repairItemDivision,repairltemName,repairltemCost,repairltemMemo,repairltemRegTime,repairltemUploadTime,repairltemUpdateTime,repairltemGlobalTime, COUNT(*) as 'COUNT', SUM(repairltemCost) as 'TotalCost',group_concat(repairltemCategoryCode,',') as'categoryCodes',group_concat(repairltemName,',') as'categoryCodesName',group_concat(repairltemMemo,',') as'carbookRecordItemMemos',group_concat(repairltemCost,',') as 'categoryCodesCost' FROM REPAIRITEM WHERE repairltemIsHidden = 0 GROUP BY repairSN ) as 'B' ON(A._id = B.repairSN) AND A.repairIsHidden = 0 \(yearSearchQuery) ORDER BY A.repairExpendDate DESC  "
            
            print("querySQL :\(querySQL)")
            var dictArray : [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(querySQL, withArgumentsIn: []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["repairExpendDate"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "repairExpendDate")
                    }
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(dictArray)")
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
            
            let yearSearchQuery = year != nil ? "WHERE date Like '\(year!)%'" : ""
            
            let querySQL =  "SELECT *,substr(fuelingExpendDate,0,7) as 'date' FROM FUELING WHERE fuelingISHidden = 0 ORDER BY fuelingExpendDate DESC "
            print("querySQL :\(querySQL)")
            var dictArray : [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(querySQL, withArgumentsIn: []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["repairExpendDate"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "repairExpendDate")
                    }
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(dictArray)")
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
    
    
    func searchCarbookDataList(name : String) -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * , substr(repairExpendDate,0,7) as 'date' FROM REPAIR as 'A' JOIN(SELECT repairSN,repairltemID,repairItemKey,repairltemIsHidden,repairltemCategoryCode,repairItemDivision,repairltemName,repairltemCost,repairltemMemo,repairltemRegTime,repairltemUploadTime,repairltemUpdateTime,repairltemGlobalTime, COUNT(*) as 'COUNT', SUM(repairltemCost) as 'TotalCost',group_concat(repairltemCategoryCode,',') as'categoryCodes',group_concat(repairltemName,',') as'categoryCodesName',group_concat(repairltemMemo,',') as'carbookRecordItemMemos',group_concat(repairltemCost,',') as 'categoryCodesCost' FROM REPAIRITEM WHERE repairltemIsHidden = 0 GROUP BY repairSN ) as 'B' ON(A._id = B.repairSN) AND A.repairIsHidden = 0  WHERE B.repairltemName Like '%\(name)%' OR B.carbookRecordItemMemos Like '%\(name)%' GROUP BY repairSN ORDER BY A.repairExpendDate DESC"

            var dictArray: [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(selectSQL, withArgumentsIn:  []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["repairExpendDate"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "repairExpendDate")
                    }
                    dictArray?.append(dict)
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
    
    
    func searchOilDataList(name : String) -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * FROM FUELING WHERE fuelingISHidden = 0 AND fuelingPlace Like '%\(name)%' OR fuelingMemo Like '%\(name)%' OR fuelingAddress Like '%\(name)%' ORDER BY fuelingExpendDate DESC"

            var dictArray: [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(selectSQL, withArgumentsIn:  []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["fuelingExpendDate"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "fuelingExpendDate")
                    }
                    dictArray?.append(dict)
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
