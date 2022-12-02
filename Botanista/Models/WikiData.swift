//
//  FlowerWikiData.swift
//  Botanista
//
//  Created by Lucinda Flores on 13/10/2022.
//

import Foundation

struct WikiData: Decodable {
    let query: Query
}

struct Query: Decodable {
    let pages: [String:Pages]
}

struct Pages: Decodable {
    let pageid: Int
    let ns: Int
    let title: String
    let extract: String
}
