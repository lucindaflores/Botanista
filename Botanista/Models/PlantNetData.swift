//
//  FlowerPlantNetData.swift
//  Botanista: Data model to use to parse the PlantNet API response.
//
//  Created by Lucinda Flores on 13/10/2022.
//

import Foundation

struct PlantNetData: Decodable {
    let results: [Results]
}
     
struct Results: Decodable {
    let score: Float
    let species: Species
}

struct Species: Decodable {
    let scientificNameWithoutAuthor: String?
    let commonNames: [String]?
    let scientificName: String
}

