import Foundation

// MARK: - CatElement
struct Cat: Codable {
    let breeds: [Breed]
    let id: String
    let url: String
}
