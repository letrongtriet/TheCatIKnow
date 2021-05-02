import Foundation
import Combine
import CoreLocation

public final class NetworkManager {
    // MARK: - Private properties
    private let baseUrlString: String

    // MARK: - Init
    init(baseUrlString: String) {
        self.baseUrlString = baseUrlString
    }

    // MARK: - Private methods
    private func executeRequest<T: Codable>(_ request: URLRequest, completion: @escaping (Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  let data = data
            else {
                DispatchQueue.main.async {
                    completion(.failure(.noResponse))
                }
                return
            }

            guard (200 ... 299).contains(response.statusCode) else {
                if let error = error as? URLError {
                    DispatchQueue.main.async {
                        completion(.failure(.url(error)))
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(.httpStatusCode(response.statusCode, data, response)))
                    }
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
            catch {
                if let error = error as? DecodingError {
                    DispatchQueue.main.async {
                        completion(.failure(.decoding(error, data)))
                    }

                }
                else {
                    DispatchQueue.main.async {
                        completion(.failure(.underlying(error)))
                    }
                }
            }
        }.resume()
    }

    private func createURLRequest(from requestType: APIRequestProtocol) -> URLRequest? {
        let urlString = baseUrlString + requestType.path

        guard var url = URL(string: urlString) else {
            return nil
        }

        if let queryParameters = requestType.queryParameters {
            var queryItems = [URLQueryItem]()
            for (name, value) in queryParameters {
                queryItems.append(.init(name: name, value: value))
            }
            if var urlComps = URLComponents(string: urlString) {
                urlComps.queryItems = queryItems
                if let queryUrl = urlComps.url {
                    url = queryUrl
                    print(url.absoluteString)
                }
            }
        }

        var request = URLRequest(url: url, timeoutInterval: 60)
        request.httpMethod = requestType.method.rawValue

        if let parameters = requestType.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }

        if let headers = requestType.headers {
            request.allHTTPHeaderFields = headers
        }

        return request
    }

    private func createRequestForUploadForm(from requestType: APIRequestProtocol) -> URLRequest? {
        let urlString = baseUrlString + requestType.path

        guard let url = URL(string: urlString) else {
            return nil
        }

        guard let parameters = requestType.parameters,
              let boundary = parameters["boundary"] as? String,
              let src = parameters["src"] as? String,
              let fileUrl = URL(string: src),
              let fileData = try? Data(contentsOf: fileUrl, options: [])
        else {
            return nil
        }

        let fieldName = "file"
        let fileName = src
        let mimeType = "image/png"

        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        data.appendString("--\(boundary)--\r\n")

        var request = URLRequest(url: url, timeoutInterval: 60)

        request.httpMethod = requestType.method.rawValue
        request.httpBody = data as Data

        if let headers = requestType.headers {
            request.allHTTPHeaderFields = headers
        }

        return request
    }
}

// MARK: - Network
extension NetworkManager: NetworkDefinition {
    func getCats(completion: @escaping (Result<[Cat], APIError>) -> Void) {
        let api = CatAPI.getCats
        guard let request = createURLRequest(from: api) else {
            completion(.failure(.invalidUrlRequest))
            return
        }
        executeRequest(request, completion: completion)
    }

    func getBreeds(completion: @escaping (Result<[Breed], APIError>) -> Void) {
        let api = CatAPI.getBreeds
        guard let request = createURLRequest(from: api) else {
            completion(.failure(.invalidUrlRequest))
            return
        }
        executeRequest(request, completion: completion)
    }

    func getFavorites(completion: @escaping (Result<[Favorite], APIError>) -> Void) {
        let api = CatAPI.getFavorites
        guard let request = createURLRequest(from: api) else {
            completion(.failure(.invalidUrlRequest))
            return
        }
        executeRequest(request, completion: completion)
    }

    func getUploads(completion: @escaping (Result<[Cat], APIError>) -> Void) {
        let api = CatAPI.getUploads
        guard let request = createURLRequest(from: api) else {
            completion(.failure(.invalidUrlRequest))
            return
        }
        executeRequest(request, completion: completion)
    }

    func uploadCat(urlString: String, boundary: String, completion: @escaping (Result<UploadCatResponse, APIError>) -> Void) {
        let api = CatAPI.uploadCat(urlString: urlString, boundary: boundary)
        guard let request = createRequestForUploadForm(from: api) else {
            completion(.failure(.invalidUrlRequest))
            return
        }
        executeRequest(request, completion: completion)
    }

    func favoriteCat(id: String, completion: @escaping (Result<FavoriteCatResponse, APIError>) -> Void) {
        let api = CatAPI.favoriteCat(id: id)
        guard let request = createURLRequest(from: api) else {
            completion(.failure(.invalidUrlRequest))
            return
        }
        executeRequest(request, completion: completion)
    }

    func unFavoriteCat(id: String, completion: @escaping (Result<UnFavoriteCatResponse, APIError>) -> Void) {
        let api = CatAPI.unFavoriteCat(id: id)
        guard let request = createURLRequest(from: api) else {
            completion(.failure(.invalidUrlRequest))
            return
        }
        executeRequest(request, completion: completion)
    }
}
