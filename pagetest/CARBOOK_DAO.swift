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
    
    func insertCarbookData(carbookData : [String:Any]) -> [String:Any] {
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
            
            let insertSQL = "Insert Into CARBOOKRECORD ( carbookRecordRepairMode,carbookRecordExpendDate,carbookRecordIsHidden,carbookRecordTotalDistance,carbookRecordRegTime,carbookRecordUpdateTime,carbookRecordType) Values('\(carbookData["carbookRecordRepairMode"]!)', '\(carbookData["carbookRecordExpendDate"]!)', '\(carbookData["carbookRecordIsHidden"]!)','\(carbookData["carbookRecordTotalDistance"]!)','\(carbookData["carbookRecordType"]!)','\(dateFormatter.string(from: date))', '\(updateFormatter.string(from: date))')"
            
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
    
    
    
    func insertCarbookItems (carbookDataItems :[Dictionary<String,Any>]) -> [Dictionary<String,Any>] {
        
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = Date()
        
        let updateFormatter = DateFormatter()
        
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {
                
                carbookDataItems.forEach{ (item) in
                    let insertSQL = "Insert Into CARBOOKRECORDITEM (carbookRecordId, carbookRecordItemCategoryCode,carbookRecordItemCategoryName,carbookRecordItemExpenseMemo,carbookRecordItemExpenseCost,carbookRecordItemIsHidden,carbookRecordItemRegTime,carbookRecordItemUpdateTime) Values('\(item["carbookRecordItemRecordId"]!)','\(item["carbookRecordItemCategoryCode"]!)','\(item["carbookRecordItemCategoryName"]!)','\(item[ "carbookRecordItemExpenseMemo"]!)','\(item["carbookRecordItemExpenseCost"]!)', '\(item["carbookRecordItemIsHidden"]!)','\(dateFormatter.string(from: date))', '\(updateFormatter.string(from: date))')"
                    
                    let result = carbookDB.executeUpdate(insertSQL, withArgumentsIn: [])
                    
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(insertSQL)")
                }
                carbookDB.commit()
                return [["result" : true]]
            }
        }
        Swift.print("Error \(carbookDB.lastErrorMessage())")
        return [["result" : false]]
    }
    
    func insertCarbookOilItems (carbookDataOilItems :[Dictionary<String,Any>]) -> [Dictionary<String,Any>] {
        
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = Date()
        
        let updateFormatter = DateFormatter()
        
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {
                
                carbookDataOilItems.forEach{ (item) in
                    let insertSQL = "Insert Into CARBOOKRECORDITEM (carbookRecordId, carbookRecordOilItemExpenseCost,carbookRecordOilItemFillFuel,carbookRecordOilItemExpenseMemo,carbookRecordOilItemFuelLiter,carbookRecordItemIsHidden,carbookRecordItemRegTime,carbookRecordItemUpdateTime) Values('\(item["carbookRecordItemRecordId"]!)','\(item[ "carbookRecordOilItemExpenseCost"]!)','\(item["carbookRecordOilItemFillFuel"]!)','\(item["carbookRecordOilItemExpenseMemo"]!)','\(item["carbookRecordOilItemFuelLiter"]!)', '\(item["carbookRecordItemIsHidden"]!)','\(dateFormatter.string(from: date))', '\(updateFormatter.string(from: date))')"
                    
                    let result = carbookDB.executeUpdate(insertSQL, withArgumentsIn: [])
                    
                    Swift.print("items:\(result)")
                    Swift.print("insertSQL:\(insertSQL)")
                }
                carbookDB.commit()
                return [["result" : true]]
            }
        }
        Swift.print("Error \(carbookDB.lastErrorMessage())")
        return [["result" : false]]
    }
    
    
    func modifyCarBookData(carbookData :[String:Any], id : String) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let date = Date()
        
        let updateFormatter = DateFormatter()
        
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let updateSQL = "UPDATE CARBOOKRECORD SET carbookRecordRepairMode = '\(carbookData["carbookRecordRepairMode"]!)', carbookRecordExpendDate = '\(carbookData["carbookRecordExpendDate"]!)', carbookRecordIsHidden = '\(carbookData["carbookRecordIsHidden"]!)', carbookRecordTotalDistance = '\(carbookData["carbookRecordTotalDistance"]!)', carbookRecordRegTime = '\(dateFormatter.string(from: Date()))', carbookRecordUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE _id = '\(id)' "
            
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
        updateFormatter.dateFormat = "yyyyMMddHHmmss"
        updateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        
        dateFormatter.locale = Locale(identifier: "ko_KR")
        updateFormatter.locale = Locale(identifier: "ko_KR")
        if carbookDB.open() {
            defer {carbookDB.close()}
            if carbookDB.beginTransaction() {
                carbookDataItem.forEach{ (item) in
                    let updateSQL = "UPDATE CARBOOKRECORDITEM SET carbookRecordId = '\(item["carbookRecordItemRecordId"]!)',  carbookRecordItemCategoryCode = '\(item["carbookRecordItemCategoryCode"]!)', carbookRecordItemCategoryName = '\(item["carbookRecordItemCategoryName"]!)', carbookRecordItemExpenseMemo = '\(item["carbookRecordItemExpenseMemo"]!)', carbookRecordItemExpenseCost = '\(item["carbookRecordItemExpenseCost"]!)',carbookRecordItemIsHidden = '\(item["carbookRecordItemIsHidden"]!)', carbookRecordItemRegTime = '\(dateFormatter.string(from: Date()))', carbookRecordItemUpdateTime = '\(updateFormatter.string(from: Date())) 'WHERE carbookRecordId = '\(item["carbookRecordItemRecordId"]!)' AND _id = '\(item["_id"]!)' "
        
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
    
    func deleteCarBookData(deleteId : Int) -> Bool{
        let carbookDB = FMDatabase(path: databaseURL?.path)
        
        if carbookDB.open() {
            defer {carbookDB.close()}
            let updateSQL = "UPDATE CARBOOKRECORD SET carbookRecordIsHidden = 1 WHERE _id = '\(deleteId)'"
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
                    let updateSQL = "UPDATE CARBOOKRECORDITEM SET carbookRecordItemIsHidden = 1 WHERE _id = '\(item)'"
        
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
    
    
    func selectCarbookData(id : String) -> [String:Any]?{
        let carbookDB = FMDatabase(path : databaseURL?.path)
        if carbookDB.open() {
            let selectSQL = "SELECT * FROM CARBOOKRECORD WHERE _id = '\(id)' AND  carbookRecordIsHidden = 0"
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
            let selectSQL = "SELECT * FROM CARBOOKRECORDITEM WHERE carbookRecordId ='\(id)' AND carbookRecordItemIsHidden = 0 ORDER BY carbookRecordItemUpdateTime DESC"
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
            
            let querySQL =  "SELECT * , substr(carbookRecordExpendDate,0,7) as 'date' FROM CARBOOKRECORD as 'A' JOIN(SELECT carbookRecordId,carbookRecordItemCategoryCode,carbookRecordItemExpenseMemo , carbookRecordItemCategoryName,carbookRecordOilItemExpenseCost,carbookRecordOilItemFuelLiter,COUNT(*) as 'COUNT', SUM(carbookRecordItemExpenseCost) as 'TotalCost',group_concat(carbookRecordItemCategoryCode,',') as'categoryCodes',group_concat(carbookRecordItemCategoryName,',') as'categoryCodesName',group_concat(carbookRecordItemExpenseMemo,',') as'carbookRecordItemMemos',group_concat(carbookRecordItemExpenseCost,',') as 'categoryCodesCost' FROM CARBOOKRECORDITEM WHERE carbookRecordItemIsHidden = 0 GROUP BY carbookRecordId ) as 'B' ON(A._id = B.carbookRecordId) AND A.carbookRecordIsHidden = 0 \(yearSearchQuery) GROUP BY carbookRecordId ORDER BY A.carbookRecordExpendDate DESC"
            
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
            let selectSQL = "SELECT * , substr(carbookRecordExpendDate,0,7) as 'date' FROM CARBOOKRECORD as 'A' JOIN(SELECT carbookRecordId,carbookRecordItemCategoryCode,carbookRecordItemExpenseMemo , carbookRecordItemCategoryName,COUNT(*) as 'COUNT', SUM(carbookRecordItemExpenseCost) as 'TotalCost',group_concat(carbookRecordItemCategoryCode,',') as'categoryCodes',group_concat(carbookRecordItemCategoryName,',') as'categoryCodesName',group_concat(carbookRecordItemExpenseMemo,',') as'carbookRecordItemMemos',group_concat(carbookRecordItemExpenseCost,',') as 'categoryCodesCost' FROM CARBOOKRECORDITEM WHERE carbookRecordItemIsHidden = 0 GROUP BY carbookRecordId ) as 'B' ON(A._id = B.carbookRecordId) AND A.carbookRecordIsHidden = 0 WHERE B.categoryCodesName Like '%\(name)%' OR B.carbookRecordItemMemos Like '%\(name)%' GROUP BY carbookRecordId ORDER BY A.carbookRecordExpendDate DESC"
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
