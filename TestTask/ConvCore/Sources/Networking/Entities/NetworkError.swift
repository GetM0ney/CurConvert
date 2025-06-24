public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidParameters
    case httpError(Int)
    case decodingError(Error)
    case apiError(APIError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidParameters:
            return "Invalid parameters"
        case let .httpError(code):
            return "HTTP error: \(code)"
        case let .decodingError(error):
            return "Decoding error: \(error.localizedDescription)"
        case let .apiError(error):
            return error.message
        case let .unknown(error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

public struct APIError: Codable {
    let code: String
    let message: String
}
