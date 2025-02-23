enum APIServiceError: Error {

    case invalidURL
    case responseError
    case decodingError
    case unknownError
    case requestCreationError
}
