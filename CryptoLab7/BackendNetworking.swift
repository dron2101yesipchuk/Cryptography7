//
//  BackendNetworking.swift
//  CryptoLab7
//
//  Created by Dron on 10.04.2020.
//  Copyright © 2020 com.dron. All rights reserved.
//

import Foundation

//Структура для отримання даних
struct Info: Codable {
    var id: Int
    var name: String
    var value: String
    
    init(id: Int, name: String, value: String) {
        self.id = id
        self.name = name
        self.value = value
    }
    
    func getInfo() -> String {
        return "id: \(id); name:\(name); value:\(value);"
    }
}

//Синглтон клас для запитів
class Networking {
    static let shared = Networking()
    
    //MARK: - Lab8
    func login(username: String, password: String, success: @escaping ([Info])->(), failure: @escaping (String)->()) {
        let urlString = "http://localhost:8080/getResources"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let info = try? JSONDecoder().decode([Info].self, from: data) {
                    success(info)
                } else {
                    failure("Error")
                }
            }
        }).resume()
    }
    
    func getIds(username: String, password: String, success: @escaping ([Int])->(), failure: @escaping (String)->()) {
        let urlString = "http://localhost:8080/secretResource/ids"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let info = try? JSONDecoder().decode([Int].self, from: data) {
                    success(info)
                } else {
                    failure("Error")
                }
            }
        }).resume()
    }
    
    func createInfo(id: Int, username: String, password: String, success: @escaping (Int)->(), failure: @escaping (String)->()) {
        let urlString = "http://localhost:8080/secretResource/"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let json: [String:Any] = ["id":id,
                                  "name":"\(username) resource #\(id)",
            "value":id]
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = data
            
            session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                        let dataResource = json["data"] as? NSDictionary {
                        if let infoID = dataResource["id"] as? Int{
                            success(infoID)
                        } else if let outputStr = String(data: data, encoding: String.Encoding.utf8) {
                            print(outputStr)
                        } else {
                            failure("Error")
                        }
                    } else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let error = json["error"] as? String {
                        
                        failure(error)
                        
                    } else if let outputStr = String(data: data, encoding: String.Encoding.utf8) {
                        print(outputStr)
                    } else {
                        failure("Error")
                    }
                }
            }).resume()
        } catch let error {
            failure(error.localizedDescription)
        }
        
    }
    
    func readInfo(id: Int, username: String, password: String, success: @escaping (Info)->(), failure: @escaping (String)->()) {
        let urlString = "http://localhost:8080/secretResource/?id=\(id)"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let data = data {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                    let dataResource = json["data"] as? NSDictionary {
                    if let infoID = dataResource["id"] as? Int,
                        let infoName = dataResource["name"] as? String,
                        let infoValue = dataResource["value"] as? String {
                        success(Info(id: infoID, name: infoName, value: infoValue))
                    } else if let outputStr = String(data: data, encoding: String.Encoding.utf8) {
                        print(outputStr)
                    } else {
                        failure("Error")
                    }
                } else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let error = json["error"] as? String {
                    
                    failure(error)
                    
                } else if let outputStr = String(data: data, encoding: String.Encoding.utf8) {
                    print(outputStr)
                } else {
                    failure("Error")
                }
            }
        }).resume()
    }
    
    func changeInfo(id: Int, username: String, password: String, success: @escaping (Info)->(), failure: @escaping (String)->()) {
        let urlString = "http://localhost:8080/secretResource/"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let json: [String:Any] = ["id":id,
                                  "name":"\(username) resource #\(id) changed",
            "value":id*10]
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            request.httpBody = data
            
            session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary,
                        let dataResource = json["data"] as? NSDictionary {
                        if let infoID = dataResource["id"] as? Int,
                            let infoName = dataResource["name"] as? String,
                            let infoValue = dataResource["value"] as? String {
                            success(Info(id: infoID, name: infoName, value: infoValue))
                            
                        } else if let outputStr = String(data: data, encoding: String.Encoding.utf8) {
                            print(outputStr)
                        } else {
                            failure("Error")
                        }
                    } else if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary, let error = json["error"] as? String {
                        
                        failure(error)
                        
                    } else if let outputStr = String(data: data, encoding: String.Encoding.utf8) {
                        print(outputStr)
                    } else {
                        failure("Error")
                    }
                }
                
            }).resume()
        } catch let error {
            failure(error.localizedDescription)
        }
    }
    
    //MARK: - Lab7
    //    Функція для отримання даних без авторизації
    func getDataWithoutAuthorization(success: @escaping ([Info])->(), failure: @escaping (String)->()) {
        let urlString = "http://localhost:8080/test"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            
            if let data = data
            {
                //let data = try?  JSONSerialization.data(withJSONObject: response, options: .prettyPrinted),
                if  let info = try? JSONDecoder().decode([Info].self, from: data) {
                    success(info)
                } else {
                    failure("Error")
                }
                
            }
        }).resume()
    }
    //    Функція для отримання даних з авторизацією
    func getDataWithAuthorization(username: String, password: String, success: @escaping ([Info])->(), failure: @escaping (String)->()) {
        let urlString = "http://localhost:8080/getResources"
        let session = URLSession.shared
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let info = try? JSONDecoder().decode([Info].self, from: data) {
                    success(info)
                } else {
                    failure("Error")
                }
            }
        }).resume()
    }
    
    
}

