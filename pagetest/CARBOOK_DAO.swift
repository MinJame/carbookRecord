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
            let uploadDateFormmatter = DateFormatter()
            let updateFormatter = DateFormatter()
            let globalDateFormatter = DateFormatter()
            regDateFormmatter.dateFormat = "yyyyMMddHHmmss"
            uploadDateFormmatter.dateFormat = "yyyyMMddHHmmss"
            updateFormatter.dateFormat = "yyyyMMddHHmmss"
            globalDateFormatter.dateFormat =  "yyyyMMddHHmmss"
            updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
            
            
            dateFormatter.locale = Locale(identifier: "ko_KR")
            regDateFormmatter.locale = Locale(identifier: "ko_KR")
            uploadDateFormmatter.locale = Locale(identifier: "ko_KR")
            updateFormatter.locale = Locale(identifier: "ko_KR")
            globalDateFormatter.locale =  Locale(identifier: "ko_KR")
            let insertSQL = "Insert Into REPAIR ( carSN,repairID,repairKey,repairIsHidden,repairMode,repairPlace,repairAddress,repairLatitude,repairLongitude,repairExpendDate,repairDist,repairImage,repairRegTime,repairUploadTime,repairUpdateTime,repairGlobalTime) Values('\(carbookData["carSN"]!)','\(dateFormatter.string(from:date))','\(carbookData["repairKey"]!)','\(carbookData["repairIsHidden"]!)','\(carbookData["repairMode"]!)','\(carbookData["repairPlace"]!)','\(carbookData["repairAddress"]!)','\(carbookData["repairLatitude"]!)','\(carbookData["repairLongitude"]!)','\(carbookData["repairExpendDate"]!)','\(carbookData["repairDist"]!)','\(carbookData["repairImage"]!)','\(regDateFormmatter.string(from: date))','\(uploadDateFormmatter.string(from: date))','\(updateFormatter.string(from: date))','\(globalDateFormatter.string(from: date))')"
            
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
        let uploadDateFormmatter = DateFormatter()
        let updateFormatter = DateFormatter()
        let globalDateFormatter = DateFormatter()
        regDateFormmatter.dateFormat = "yyyyMMddHHmmss"
        uploadDateFormmatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        globalDateFormatter.dateFormat =  "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        regDateFormmatter.locale = Locale(identifier: "ko_KR")
        uploadDateFormmatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        globalDateFormatter.locale =  Locale(identifier: "ko_KR")
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {
                
                carbookDataItems.forEach{ (item) in
                    let insertSQL = "Insert Into REPAIRITEM (repairSN, repairltemID,repairItemKey,repairltemIsHidden,repairltemCategoryCode,repairItemDivision,repairltemName,repairltemCost,repairltemMemo,repairltemRegTime,repairltemUploadTime,repairltemUpdateTime,repairltemGlobalTime) Values('\(item["repairSN"]!)','\(dateFormatter.string(from: date))','\(item["repairItemKey"]!)','\(item["repairltemIsHidden"]!)','\(item[ "repairltemCategoryCode"]!)','\(item["repairItemDivision"]!)', '\(item["repairltemName"]!)','\(item["repairltemCost"]!)','\(item["repairltemMemo"]!)','\(regDateFormmatter.string(from: date))','\(uploadDateFormmatter.string(from: date))','\(dateFormatter.string(from: date))', '\(globalDateFormatter.string(from: date))')"
                    
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
    
    func insertCarbookOilItems(carbookDataOilItems : [String:Any]) -> [String:Any] {
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let date = Date()
            
            let updateFormatter = DateFormatter()
            
            updateFormatter.dateFormat = "yyyyMMddHHmmss"
            updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
            
            dateFormatter.locale = Locale(identifier: "ko_KR")
            updateFormatter.locale = Locale(identifier: "ko_KR")
            
            let insertSQL = "Insert Into CARBOOKRECORDOILITEM (carbookRecordId, carbookRecordOilItemExpenseCost,carbookRecordOilItemFillFuel,carbookRecordOilItemFuelLiter,carbookRecordOilItemType,carbookRecordWashCost,carbookRecordFuelStatus,carbookRecordFuelPercentage ,carbookRecordItemIsHidden,carbookRecordItemRegTime,carbookRecordItemUpdateTime) Values('\(carbookDataOilItems["carbookRecordItemRecordId"]!)','\(carbookDataOilItems[ "carbookRecordOilItemExpenseCost"]!)','\(carbookDataOilItems["carbookRecordOilItemFillFuel"]!)','\(carbookDataOilItems["carbookRecordOilItemFuelLiter"]!)','\(carbookDataOilItems["carbookRecordOilItemType"]!)', '\(carbookDataOilItems["carbookRecordWashCost"]!)', '\(carbookDataOilItems["carbookRecordFuelStatus"]!)', '\(carbookDataOilItems["carbookRecordFuelPercentage"]!)', '\(carbookDataOilItems["carbookRecordItemIsHidden"]!)','\(dateFormatter.string(from: date))', '\(updateFormatter.string(from: date))')"
            //
            
            Swift.print("저기는 : \(insertSQL)")
            
            let result = carbookDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result {
                Swift.print("Error \(carbookDB.lastErrorMessage())")
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
            let updateSQL = "UPDATE REPAIR SET repairIsHidden = '\(carbookData["repairIsHidden"]!)',repairMode = '\(carbookData["carbookRrepairModeecordRepairMode"]!)', repairPlace = '\(carbookData["repairPlace"]!)', repairAddress = '\(carbookData["repairAddress"]!)', repairLatitude = '\(carbookData["repairLatitude"]!)', repairLongitude = '\(carbookData["repairLongitude"]!)',repairExpendDate = '\(carbookData["repairExpendDate"]!)',repairDist = '\(carbookData["repairDist"]!)',repairImage = '\(carbookData["repairImage"]!)', repairUploadTime = '\(uploadDateFormmatter.string(from: Date())) 'WHERE _id = '\(id)', repairUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE _id = '\(id)' "
            
            let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
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
                    let updateSQL = "UPDATE REPAIRITEM SET repairltemID = '\(item["repairltemID"]!)',  repairltemIsHidden = '\(item["repairltemIsHidden"]!)', repairltemCategoryCode = '\(item["repairltemCategoryCode"]!)', repairItemDivision = '\(item["repairItemDivision"]!)', repairltemName = '\(item["repairltemName"]!)',repairltemCost = '\(item["repairltemCost"]!)',repairltemMemo = '\(item["repairltemMemo"]!)', repairltemUploadTime = '\(uploadDateFormmatter.string(from: Date()))', carbookRecordItemUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE repairltemID = '\(item["repairltemID"]!)' AND _id = '\(item["_id"]!)' "
        
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
    
    
    
    func modifyCarBookDataOilItem(carbookDataOilItem : [String:Any]) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let updateFormatter = DateFormatter()
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {

                    let updateSQL = "UPDATE CARBOOKRECORDOILITEM SET carbookRecordId = '\(carbookDataOilItem["carbookRecordItemRecordId"]!)',  carbookRecordOilItemExpenseCost = '\(carbookDataOilItem["carbookRecordOilItemExpenseCost"]!)', carbookRecordOilItemFillFuel = '\(carbookDataOilItem["carbookRecordOilItemFillFuel"]!)', carbookRecordOilItemFuelLiter = '\(carbookDataOilItem["carbookRecordOilItemFuelLiter"]!)',carbookRecordOilItemType = '\(carbookDataOilItem["carbookRecordOilItemType"]!)',carbookRecordWashCost = '\(carbookDataOilItem["carbookRecordWashCost"]!)',carbookRecordFuelStatus = '\(carbookDataOilItem["carbookRecordFuelStatus"]!)',carbookRecordFuelPercentage = '\(carbookDataOilItem["carbookRecordFuelPercentage"]!)',carbookRecordItemIsHidden = '\(carbookDataOilItem["carbookRecordItemIsHidden"]!)', carbookRecordItemRegTime = '\(dateFormatter.string(from: Date()))', carbookRecordItemUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE carbookRecordId = '\(carbookDataOilItem["carbookRecordItemRecordId"]!)' AND _id = '\(carbookDataOilItem["_id"]!)'"
        
                    let result = carbookDB.executeUpdate(updateSQL, withArgumentsIn: [])
                    
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(updateSQL)")
                }
                carbookDB.commit()
                return true
            }
        Swift.print("Error \(carbookDB.lastErrorMessage())")
        return false
    }
    
    func deleteCarBookData(deleteId : Int) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let updateSQL = "UPDATE CARBOOKRECORD SET repairIsHidden = 1 WHERE _id = '\(deleteId)'"
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
    
    
    
    func selectCarbookDataList(id : String) -> [Dictionary<String, Any>]?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * FROM REPAIRITEM WHERE carbookRecordId ='\(id)' AND carbookRecordItemIsHidden = 0 ORDER BY carbookRecordItemUpdateTime DESC"
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

            let querySQL = "SELECT DISTINCT substr(carbookRecordExpendDate,0,5) as 'year',substr(carbookRecordExpendDate,5,2) as 'month' FROM CARBOOKRECORD Where carbookRecordIsHidden = 0 ORDER BY year DESC, month DESC"
       
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
            
            let querySQL =  "SELECT * , substr(carbookRecordExpendDate,0,7) as 'date' FROM CARBOOKRECORD as 'A' JOIN(SELECT carbookRecordId,carbookRecordItemCategoryCode,carbookRecordItemExpenseMemo , carbookRecordItemCategoryName,COUNT(*) as 'COUNT', SUM(carbookRecordItemExpenseCost) as 'TotalCost',group_concat(carbookRecordItemCategoryCode,',') as'categoryCodes',group_concat(carbookRecordItemCategoryName,',') as'categoryCodesName',group_concat(carbookRecordItemExpenseMemo,',') as'carbookRecordItemMemos',group_concat(carbookRecordItemExpenseCost,',') as 'categoryCodesCost' FROM CARBOOKRECORDREPAIRITEM WHERE carbookRecordItemIsHidden = 0 GROUP BY carbookRecordId ) as 'B'   JOIN(SELECT carbookRecordId,carbookRecordOilItemExpenseCost,carbookRecordOilItemFillFuel,carbookRecordOilItemFuelLiter,carbookRecordOilItemType,carbookRecordWashCost,carbookRecordFuelStatus,carbookRecordItemIsHidden,carbookRecordItemRegTime,carbookRecordItemUpdateTime FROM carbookRecordOilItem WHERE carbookRecordItemIsHidden = 0) as 'C' ON(A._id = B.carbookRecordId  OR A._id = C.carbookRecordId  ) AND A.carbookRecordIsHidden = 0 \(yearSearchQuery)ORDER BY A.carbookRecordExpendDate DESC  "
            
            print("querySQL :\(querySQL)")
            var dictArray : [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(querySQL, withArgumentsIn: []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["carbookExpendTime"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "carbookExpendTime")
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
            let selectSQL = "SELECT * , substr(carbookRecordExpendDate,0,7) as 'date' FROM CARBOOKRECORD as 'A' JOIN(SELECT carbookRecordId,carbookRecordItemCategoryCode,carbookRecordItemExpenseMemo ,carbookRecordItemCategoryName,COUNT(*) as 'COUNT', SUM(carbookRecordItemExpenseCost) as 'TotalCost',group_concat(carbookRecordItemCategoryCode,',') as'categoryCodes',group_concat(carbookRecordItemCategoryName,',') as'categoryCodesName',group_concat(carbookRecordItemExpenseMemo,',') as'carbookRecordItemMemos',group_concat(carbookRecordItemExpenseCost,',') as 'categoryCodesCost' FROM CARBOOKRECORDITEM WHERE carbookRecordItemIsHidden = 0 GROUP BY carbookRecordId ) as 'B' ON(A._id = B.carbookRecordId) AND A.carbookRecordIsHidden = 0 WHERE A.carbookRecordType Like '%\(name)%'OR B.categoryCodesName Like '%\(name)%' OR B.carbookRecordItemMemos Like '%\(name)%' GROUP BY carbookRecordId ORDER BY A.carbookRecordExpendDate DESC"
            var dictArray: [Dictionary<String, Any>]? = []
            if let result : FMResultSet = carbookDB.executeQuery(selectSQL, withArgumentsIn:  []) {
                var dict : Dictionary<String, Any> = [:]
                while result.next() {
                    dict = result.resultDictionary as! [String : Any]
                    if let date = dict["carbookExpendTime"] as? String{
                        dict.updateValue("\(date.components(separatedBy: ["-"]).joined())", forKey: "carbookExpendTime")
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
