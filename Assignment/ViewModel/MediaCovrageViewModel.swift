//
//  MediaCovrageViewModel.swift
//  Assignment
//
//  Created by Pramod Shukla on 11/05/24.
//

import Foundation

// ViewModel
class MediaCoverageViewModel {
    
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func fetchMediaCoverages(completion: @escaping ([MediaCoverage]) -> Void, onError: @escaping (Error) -> Void) {
        apiManager.getMediaCoverages(completion: completion, onError: onError)
    }
}
