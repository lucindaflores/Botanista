//
//  NetworkManager.swift
//  Botanista
//
//  Created by Lucinda Flores on 25/10/2022.
//

import UIKit
import Alamofire

protocol NetworkManagerDelegate {
    func populateWikiInfo(wikiInfo: WikiModel)
    func didFailWithError(error: BtErrors)
}


class NetworkManager {
    
    var delegate: NetworkManagerDelegate?

    var wikiInfoModel = WikiModel()
    
    var flowerName : String = ""
    var anErrorOcurred : Bool = false
    
    
    func startRequest(with cameraImage: UIImage){
        uploadCameraImage(image: cameraImage, completion: {
            
            if !self.anErrorOcurred {
                self.fetchFlowerData(with: self.flowerName, completion: {
                    self.delegate?.populateWikiInfo(wikiInfo: self.wikiInfoModel)
                }  )
            }
            
        })
    }
    
    
    func uploadCameraImage(image: UIImage, completion: @escaping () -> Void) {
        let plantNetKey = getAPIKeyValue(named: plantNetAPI.apiKey)
        let apiEndPoint = plantNetAPI.baseURL + "?" + plantNetAPI.apiKeyField + "=" + plantNetKey
        print("plantNetAPI \(apiEndPoint)")
        guard let finalURL = URL(string: apiEndPoint) else {
            anErrorOcurred = true
            delegate?.didFailWithError(error: BtErrors.invalidRequest)
            return
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            let imageJPEG = image.jpegData(compressionQuality: plantNetAPI.qualityValue)!
            
            multipartFormData.append(imageJPEG, withName: plantNetAPI.imagesField, fileName: plantNetAPI.imagesPathValue, mimeType: plantNetAPI.mimeTypeValue)
            multipartFormData.append(plantNetAPI.organsValue.data(using: String.Encoding.utf8)!, withName: plantNetAPI.organsField)
            
            print(multipartFormData.contentLength)
            print(multipartFormData.contentType)
        
        }, to: finalURL, method: .post)
            .uploadProgress { progress in
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
            }
            .responseDecodable(of: PlantNetData.self) { response in
                debugPrint(response)
                switch response.result {
                    
                case .success:
                    guard let plantNetResponse = response.value else {
                        self.delegate?.didFailWithError(error: BtErrors.invalidResponseServer)
                        return
                    }
                    
                    print("PlanNet response: \(plantNetResponse)")
                    let scientificNameWithoutAuthor = plantNetResponse.results[0].species.scientificNameWithoutAuthor
                    let scientificName = plantNetResponse.results[0].species.scientificName
                    
                    
                    self.flowerName = scientificNameWithoutAuthor ?? scientificName
                    print("FLOWER NAME: \(self.flowerName)")
                    
                    for abbrevation in scientificNamesAbbreviations where self.flowerName.hasSuffix(abbrevation) {
                        self.flowerName = self.flowerName.replacingOccurrences(of: abbrevation, with: "")
                    }
                
                    
                case .failure(let error):
                    self.detailedAFError(error: error)
                }
                
                completion()
                
                
            }
        
    }
    
    
    func fetchFlowerData(with name: String, completion: @escaping () -> Void) {
        AF.request(wikiAPI.baseURL, method: .get, parameters: wikiParameters(using: name))
                .responseDecodable(of: WikiData.self) { response in
                    
                    switch response.result {
                    case .success:
                        guard let wikiResponse = response.value else {
                            self.delegate?.didFailWithError(error: BtErrors.invalidRequest)
                            return
                        }
                        print("Wiki response: \(wikiResponse)")
                        
                        let pageId = wikiResponse.query.pages.first?.key ?? valueNA
                        let title = wikiResponse.query.pages.first?.value.title ?? valueNA
                        let extracts = wikiResponse.query.pages.first?.value.extract ?? valueNA
                       
                        self.wikiInfoModel = WikiModel(pageid: pageId, title: title, extract: extracts)
                        print("wikiInfoModel \(self.wikiInfoModel )")
                    case .failure(let error):
                        print(error)
                        self.detailedAFError(error: error)
                        
                }
                completion()
                
        }
    }
    
    
    func detailedAFError(error: AFError) {
        anErrorOcurred = true
        
        switch error {
            
        case .parameterEncodingFailed(let reason):
            print("Invalid response reason: \(reason)")
            self.delegate?.didFailWithError(error: BtErrors.invalidResponseServer)
            
        case .multipartEncodingFailed(let reason):
            print("Multipart encoding failed: \(reason)")
            self.delegate?.didFailWithError(error: BtErrors.invalidResponseServer)
            
        case .responseValidationFailed(let reason):
            print("Failure Reason: \(reason)")
            self.delegate?.didFailWithError(error: BtErrors.invalidResponseServer)
            
            switch reason {
            case .dataFileNil, .dataFileReadFailed:
                print("File could not be read")
                self.delegate?.didFailWithError(error: BtErrors.invalidPictureReceived)
                
            case .missingContentType(let acceptableContentTypes):
                print("Content Type Missing: \(acceptableContentTypes)")
                self.delegate?.didFailWithError(error: BtErrors.invalidPictureReceived)
                
            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                self.delegate?.didFailWithError(error: BtErrors.invalidPictureReceived)
                
            case .unacceptableStatusCode(let code):
                print("Response status code was unacceptable: \(code)")
                self.delegate?.didFailWithError(error: BtErrors.connectionError)
                
            default:
                print("Unknown error: \(error)")
                self.delegate?.didFailWithError(error: BtErrors.invalidResponseServer)
            }
            
        case .responseSerializationFailed(let reason):
            print("Response serialization failed Reason: \(reason)")
            self.delegate?.didFailWithError(error: BtErrors.invalidPictureReceived)
            
        default:
            print("Underlying error: \(String(describing: error.underlyingError?.localizedDescription))")
            self.delegate?.didFailWithError(error: BtErrors.invalidResponseServer)
        }
        
    }
    
}

