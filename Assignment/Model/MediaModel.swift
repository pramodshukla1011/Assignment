//
//  MediaModel.swift
//  Assignment
//
//  Created by Pramod Shukla on 11/05/24.
//

import Foundation

// MARK: - MediaCoverage
struct MediaCoverage: Codable {
    let id, title: String
    let language: Language
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt, publishedBy: String
    let backupDetails: BackupDetails?
}

// MARK: - BackupDetails
struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
}

enum Language: String, Codable {
    case english = "english"
    case hindi = "hindi"
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let id: String
    let version: Int
    let domain: String
    let basePath: String
    let key: Key
    let qualities: [Int]
    let aspectRatio: Double
}

enum Key: String, Codable {
    case imageJpg = "image.jpg"
}
