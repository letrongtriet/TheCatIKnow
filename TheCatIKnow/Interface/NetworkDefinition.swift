import Foundation

protocol NetworkDefinition {
    func getCats(completion: @escaping (Result<[Cat], APIError>) -> Void)
    func getBreeds(completion: @escaping (Result<[Breed], APIError>) -> Void)
    func getFavorites(completion: @escaping (Result<[Favorite], APIError>) -> Void)
    func getUploads(completion: @escaping (Result<[Cat], APIError>) -> Void)

    func uploadCat(urlString: String, boundary: String, completion: @escaping (Result<UploadCatResponse, APIError>) -> Void)

    func favoriteCat(id: String, completion: @escaping (Result<FavoriteCatResponse, APIError>) -> Void)
    func unFavoriteCat(id: String, completion: @escaping (Result<UnFavoriteCatResponse, APIError>) -> Void)
}
