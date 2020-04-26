//
//  LogService.swift
//  CryptoLab7
//
//  Created by Dron on 26.04.2020.
//  Copyright © 2020 com.dron. All rights reserved.
//

import Foundation

struct Log {
    var username: String = ""
    var date: Date = Date()
    var message: String = ""
    
    func getLog() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return "\(username)|\(formatter.string(from: date))|\(message)"
    }
}

class LogService {
    
    static let shared: LogService = LogService()
    
    init() {
        
    }
    
    var logs: [String] = []
    
    func log(log: Log){

        let logString = "\(log.getLog())\n---------------------------------\n"
        
        print(logString)
        self.logs.append(logString)
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
