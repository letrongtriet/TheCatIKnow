import Foundation

struct UploadCatResponse: Codable {
    let id: String
    let url: String
    let pending, approved: Int
}
