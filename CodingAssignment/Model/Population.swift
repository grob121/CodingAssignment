import Foundation

struct PopulationResponse: Codable {
    var data: [Population]
    var source: [Source]
}

struct Population: Codable {
    let yearId: Int
    let idNation: String
    let nation: String
    let year: String
    let population: Int
    let slugNation: String
    
    enum CodingKeys: String, CodingKey {
        case idNation = "ID Nation"
        case nation = "Nation"
        case yearId = "ID Year"
        case year = "Year"
        case population = "Population"
        case slugNation = "Slug Nation"
    }
}

struct Source: Codable {
    let measures: [String]
    let annotations: Annotations
    let name: String
    let substitutions: [String]
}

struct Annotations: Codable {
    let sourceName: String
    let sourceDescription: String
    let datasetName: String
    let datasetLink: String
    let tableId: String
    let topic: String
    let subtopic: String
    
    enum CodingKeys: String, CodingKey {
        case sourceName = "source_name"
        case sourceDescription = "source_description"
        case datasetName = "dataset_name"
        case datasetLink = "dataset_link"
        case tableId = "table_id"
        case topic = "topic"
        case subtopic = "subtopic"
    }
}
