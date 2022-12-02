//
//  Constants.swift
//  Botanista
//
//  Created by Lucinda Flores on 15/11/2022.
//  Utilities
//

import Foundation

let valueNA = "NA"
let scientificNamesAbbreviations = ["var.", "ssp.", "spp.", "subsp.", "forma", "f."]
let loadingMessageText = """
                            One moment please,
                            we are analizing your picture...
                            """

enum plantNetAPI {
    static let apiKey = "API_KEY"
    static let baseURL = "https://my-api.plantnet.org/v2/identify/all"
    static let apiKeyField = "api-key"
    
    static let organsField = "organs"
    static let organsValue = "flower"
    static let imagesField = "images"
    static let qualityValue = 0.5
    static let imagesPathValue = "/data/media/image_1.jpeg"
    static let mimeTypeValue = "image/jpeg"
}

enum wikiAPI {
    static let baseURL = "https://en.wikipedia.org/w/api.php?"
}


enum wikiURLSearch {
    static let pageURL = "https://en.wikipedia.org/?curid="
}
    
func wikiParameters(using name: String) -> [String : String] {
    let wikiParameters : [String : String] =
                         ["action" : "query",
                          "format" : "json",
                          "prop": "extracts",
                          "titles" : name,
                          "redirects" : "1",
                          "exintro" :"1",
                          "explaintext" : "1"]
    
    return wikiParameters
}


    





    

