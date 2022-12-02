//
//  BtErrors.swift
//  Botanista
//
//  Created by Lucinda Flores on 08/11/2022.
//  Utilities
//

import Foundation

enum BtErrors: String, Error {
    case connectionError = "Unable to complete your request. Please check your internet connection."
    case timedOut = "The request is taking too long. Please try again."
    case invalidRequest = "This picture created an invalid request. Please try again."
    case invalidResponseServer = "The server was not able to complete your request. Please try again."
    case invalidPictureReceived = "The server was not able to identify the picture. Please try again."
}
