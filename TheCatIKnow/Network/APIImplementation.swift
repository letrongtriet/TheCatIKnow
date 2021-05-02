import Foundation

extension CatAPI: APIRequestProtocol {
    var path: String {
        switch self {
        case .getCats:
            return "/images/search"
        case .getBreeds:
            return "/breeds"
        case .getFavorites:
            return "/favourites"
        case .uploadCat:
            return "/images/upload"
        case .favoriteCat:
            return "/favourites"
        case let .unFavoriteCat(id):
            return "/favourites/\(id)"
        case .getUploads:
            return "/images"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getCats:
            return .get
        case .getBreeds:
            return .get
        case .getFavorites:
            return .get
        case .uploadCat:
            return .post
        case .favoriteCat:
            return .post
        case .unFavoriteCat:
            return .delete
        case .getUploads:
            return .get
        }
    }

    var headers: ReaquestHeaders? {
        switch self {
        case .getCats:
            var headers = ["x-api-key": Constants.API.apiKey]
            headers["Content-Type"] = "application/json"
            return headers
        case .getBreeds:
            return nil
        case .getFavorites:
            var headers = ["x-api-key": Constants.API.apiKey]
            headers["Content-Type"] = "application/json"
            return headers
        case let .uploadCat(_, boundary):
            var headers = ["x-api-key": Constants.API.apiKey]
            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
            return headers
        case .favoriteCat:
            var headers = ["x-api-key": Constants.API.apiKey]
            headers["Content-Type"] = "application/json"
            return headers
        case .unFavoriteCat:
            var headers = ["x-api-key": Constants.API.apiKey]
            headers["Content-Type"] = "application/json"
            return headers
        case .getUploads:
            var headers = ["x-api-key": Constants.API.apiKey]
            headers["Content-Type"] = "application/json"
            return headers
        }
    }

    var parameters: RequestParameters? {
        switch self {
        case .getCats:
            return nil
        case .getBreeds:
            return nil
        case .getFavorites:
            return nil
        case let .uploadCat(urlString, boundary):
            var requestParameters = ["src": urlString]
            requestParameters["boundary"] = boundary
            return requestParameters
        case let .favoriteCat(id):
            return ["image_id": id]
        case .unFavoriteCat:
            return nil
        case .getUploads:
            return nil
        }
    }

    var queryParameters: RequestQueryParameters? {
        switch self {
        case .getCats:
            var queryParameters = ["has_breeds": "1"]
            queryParameters["limit"] = "25"
            return queryParameters
        case .getBreeds:
            return nil
        case .getFavorites:
            return nil
        case .uploadCat:
            return nil
        case .favoriteCat:
            return nil
        case .unFavoriteCat:
            return nil
        case .getUploads:
            return ["limit": "10"]
        }
    }
}
