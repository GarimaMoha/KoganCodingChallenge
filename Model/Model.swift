import Foundation

struct Equipments: Codable, Equatable {
    let objects: [Objects]
    let next: String?
}

struct Objects: Codable, Equatable {
    let category: String
    let weight: Double?
    let size: Size
}

struct Size: Codable, Equatable {
    let width: Double?
    let length: Double?
    let height: Double?
}
