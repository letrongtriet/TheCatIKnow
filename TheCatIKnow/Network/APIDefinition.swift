import Foundation
import CoreLocation

typealias ReaquestHeaders = [String: String]
typealias RequestParameters = [String : Any?]
typealias RequestQueryParameters = [String : String]
typealias Closure<T> = (T) -> Void

protocol APIRequestProtocol {
    var path: String { get }
    var method: RequestMethod { get }
    var headers: ReaquestHeaders? { get }
    var parameters: RequestParameters? { get }
    var queryParameters: RequestQueryParameters? { get }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error, Equatable {
    case invalidUrlRequest
    case invalidResponse
    case noResponse
    case badRequest(String?)
    case serverError(String?)
    case parseError(String?)
    case url(Error?)
    case unknown
    case httpStatusCode(_ code: Int, _ data: Data?,
                        _ response: HTTPURLResponse)
    case underlying(Error?)
    case decoding(Error?, Data?)

    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

enum CatAPI {
    case getCats
    case getBreeds
    case getFavorites
    case uploadCat(urlString: String, boundary: String)
    case favoriteCat(id: String)
    case unFavoriteCat(id: String)
    case getUploads
}
