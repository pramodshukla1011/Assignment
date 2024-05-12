//
//  ApiManager.swift
//  Assignment
//
//  Created by Pramod Shukla on 11/05/24.
//

import Foundation

// Define networking errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noInternet
    case unknownError
    // Add more networking errors as needed
}

// APIManager
class APIManager {
    static let shared = APIManager()
    private let baseURL = "https://acharyaprashant.org/api/v2/content/misc/media-coverages"
    private init() {}
    
    func getMediaCoverages(completion: @escaping ([MediaCoverage]) -> Void, onError: @escaping (Error) -> Void) {
        
        guard let url = URL(string: "\(baseURL)?limit=100") else {
            print("Invalid URL")
            onError(NetworkError.invalidURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let error = error as? URLError, error.code == .notConnectedToInternet {
                // Handle no internet connection
                onError(NetworkError.noInternet)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                onError(NetworkError.invalidResponse)
                return
            }
            
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                onError(NetworkError.unknownError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let mediaCoverages = try decoder.decode([MediaCoverage].self, from: data)
                completion(mediaCoverages)
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                onError(error)
            }
        }.resume()
    }
}
