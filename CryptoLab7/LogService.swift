//
//  LogService.swift
//  CryptoLab7
//
//  Created by Dron on 26.04.2020.
//  Copyright © 2020 com.dron. All rights reserved.
//

import Foundation

class Log {
    var headers: [String: String]?
    var parameters: [String: Any]?
}

class LogService {
    
    static let shared: LogService = LogService()
    
    init() {
        
    }
    
    var logs: [String] = []
    
    func log(request: URLRequest){

        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)

        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"

        var requestLog = "\n---------- OUT ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            requestLog += "\n\(bodyString)\n"
        }

        requestLog += "\n------------------------->\n";
        print(requestLog)
        self.logs.append(requestLog)
    }

    func log(data: Data?, response: URLResponse?, error: Error?){

        let urlString = response?.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")

        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"

        var responseLog = "\n<---------- IN ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }

//        if let statusCode =  components?{
//            responseLog += "HTTP \(statusCode) \(path)?\(query)\n"
//        }
//        if let host = components?.host{
//            responseLog += "Host: \(host)\n"
//        }
//        for (key,value) in response?.allHeaderFields ?? [:] {
//            responseLog += "\(key): \(value)\n"
//        }
        if let body = data{
            let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "Can't render body; not utf8 encoded";
            responseLog += "\n\(bodyString)\n"
        }
        if let error = error{
            responseLog += "\nError: \(error.localizedDescription)\n"
        }

        responseLog += "<------------------------\n";
        self.logs.append(responseLog)
        print(responseLog)
    }
    
    func saveLogs() {
        var logsString = ""
        for log in self.logs {
            logsString.append("\(log)\n\n")
        }
        let filename = getDocumentsDirectory().appendingPathComponent("logs.txt")

        do {
            try logsString.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
            print(error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
