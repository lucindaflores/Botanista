//
//  APIKeys.swift
//  Botanista
//
//  Created by Lucinda Flores on 17/11/2022.
//  Utilities
//

import Foundation

func getAPIKeyValue(named keyName: String) -> String {
    let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile:filePath!)
    let value = plist?.object(forKey: keyName) as! String
    
    return value
}
