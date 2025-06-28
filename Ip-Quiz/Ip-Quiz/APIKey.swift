//
//  APIKey.swift
//  Ip-Quiz
//
//  Created by 大場史温 on 2025/06/28.
//

import Foundation

enum APIKey {
   static var key: String {
        guard let filePath = Bundle.main.path(forResource: "Gemini-Info", ofType: "plist") else { fatalError("gemini-info.plistが見つからない") }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        
        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("API_KEYのフィールドが見つからない")
        }
        
        return value
    }
}
