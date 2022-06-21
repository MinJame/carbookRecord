////
////  rePairShop Api.swift
////  pagetest
////
////  Created by min on 2022/03/17.
////
//
//import UIKit
//
///*G10oWenqnE5jME3p5gBAWBmZUbjKWnQv6pQiYzx7J0coNUykWlZ3ET%2FdYworYNRhsGlniapuiW3bJofuYmwD2w%3D%3D*/
//
//let key = "G10oWenqnE5jME3p5gBAWBmZUbjKWnQv6pQiYzx7J0coNUykWlZ3ET%2FdYworYNRhsGlniapuiW3bJofuYmwD2w%3D%3D"
//
//let urlString = "http://apis.data.go.kr/1360000/VilageFcstMsgService/getLandFcst?serviceKey=G10oWenqnE5jME3p5gBAWBmZUbjKWnQv6pQiYzx7J0coNUykWlZ3ET%2FdYworYNRhsGlniapuiW3bJofuYmwD2w%3D%3D&numOfRows=1&pageNo=1&regId=11A00101&dataType=json"
//
//
//public struct Response: Codable{
//    public let ip : String
//}
//
//public struct WeatherINF : Codable{
//    var rnSt: Int  = 0 //강수형태
//    var wf: String = "" //날씨
//}
//
//let jsonSample = """
//{
//    "rnYn" : 12,
//    "wf" : "DB112",
//    "rnSt" : 1.2
//}
//""".data(using : .utf8)!
//
//if let url = URL(string : urlString){
//    URLSession.shared.dataTask(with: url){ data, res, err in
//        if let data = data{
//            print("hey")
//            let decoder = JSONDecoder()
//            
//            //??
//            
//            print(String(decoding:data , as : UTF8.self))
//            
//            //decode is not working mabye
//            if let json = try? decoder.decode(WeatherINF.self, from : data){
//                print(json.rnSt)
//            }
//        }
//    }.resume()
//
//}
//else{
//    print("url is nil")
//}
//
//
