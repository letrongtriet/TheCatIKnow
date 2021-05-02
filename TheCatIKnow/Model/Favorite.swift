import Foundation

struct Favorite: Codable {
    let id: Int
    let createdAt: String
    let image: Image

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case image
    }
}

struct Image: Codable {
    let id: String
    let url: String
}
