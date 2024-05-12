//
//  ErrorMessageService.swift
//  Assignment
//
//  Created by Pramod Shukla on 12/05/24.
//

import Foundation

struct ErrorMessageService {
    static func errorMessage(for error: Error) -> String {
        switch error {
        case NetworkError.invalidURL:
            return "Invalid URL"
        case NetworkError.invalidResponse:
            return "Invalid response"
        case NetworkError.noInternet:
            return "No internet connection"
        case NetworkError.unknownError:
            return "An unknown error occurred"
        default:
            return "An error occurred: \(error.localizedDescription)"
        }
    }
}
