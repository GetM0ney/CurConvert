import Foundation

public protocol NetworkService {
    func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func fetch(_ endpoint: Endpoint) async throws
}

public actor NetworkServiceImp: NetworkService {
    private let isDebugLoggingEnabled = true
    private let session: URLSession = .shared
    private let maxRetries = 3

    public func fetch<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        try await fetch(endpoint, retryCount: 0)
    }

    public func fetch(_ endpoint: Endpoint) async throws {
        _ = try await fetch(endpoint, retryCount: 0) as EmptyResponse
    }
}

// MARK: - Request Processor

extension NetworkServiceImp {
    private struct EmptyResponse: Decodable {}

    private func fetch<T: Decodable>(_ endpoint: Endpoint, retryCount: Int) async throws -> T {
        do {
            let request = try await createRequest(for: endpoint)

            logCurlCommand(for: request)

            let (data, response) = try await session.data(for: request)

            logResponse(data: data, response: response as! HTTPURLResponse)

            return try handleResponse(data, response)
        } catch {
            return try await handleError(error: error, endpoint: endpoint, retryCount: retryCount) { [weak self] in
                guard let self else {
                    throw NetworkError.unknown(NSError(
                        domain: "NetworkServiceImp",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Self is nil in fetch retry"]
                    ))
                }
                return try await fetch(endpoint, retryCount: retryCount + 1)
            }
        }
    }

    private func createMultipartBody(
        file: MultipartFile,
        boundary: String
    ) -> Data {
        var body = Data()

        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(file.serverName)\"; filename=\"\(file.filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(file.mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(file.data)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }

    private func createRequest(for endpoint: Endpoint) async throws -> URLRequest {
        guard let url = endpoint.url else {
            let error = NetworkError.invalidURL
            debugPrint(error)
            throw error
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        return request
    }

    private func handleResponse<T: Decodable>(_ data: Data, _ response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            let error = NetworkError.invalidResponse
            debugPrint(error)
            throw error
        }

        guard (200 ... 299).contains(httpResponse.statusCode) else {
            if let apiError = try? createDecoder().decode(APIError.self, from: data) {
                let error = NetworkError.apiError(apiError)
                debugPrint(error)
                throw error
            }

            let error = NetworkError.httpError(httpResponse.statusCode)
            debugPrint(error)
            throw error
        }

        do {
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            }
            return try createDecoder().decode(T.self, from: data)
        } catch {
            let error = NetworkError.decodingError(error)
            debugPrint(error)
            throw error
        }
    }

    private func handleError<T>(
        error: Error,
        endpoint: Endpoint,
        retryCount: Int,
        retryClosure: @escaping () async throws -> T
    ) async throws -> T {
        if case let NetworkError.httpError(statusCode) = error,
           statusCode == 401, retryCount < maxRetries {
            return try await retryClosure()
        }
        throw error
    }
    
    private func createDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formats = [
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX",
                "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
                "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                "yyyy-MM-dd'T'HH:mm:ss.SSS",
                "yyyy-MM-dd'T'HH:mm:ssXXXXX",
                "yyyy-MM-dd'T'HH:mm:ss"
            ]
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            
            for format in formats {
                formatter.dateFormat = format
                if let date = formatter.date(from: dateString) {
                    return date
                }
            }
            
            let error = DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot decode date string \(dateString)"
            )
            
            debugPrint(error)
            throw error
        }
        return decoder
    }
}

// MARK: - Logger

extension NetworkServiceImp {
    private func logCurlCommand(for request: URLRequest) {
        guard isDebugLoggingEnabled else { return }

        var components = ["curl -v"]

        // Method
        components.append("-X \(request.httpMethod ?? "GET")")

        // Headers
        request.allHTTPHeaderFields?.forEach { key, value in
            components.append("-H '\(key): \(value)'")
        }

        // Body
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            components.append("-d '\(bodyString)'")
        }

        // URL
        components.append("'\(request.url?.absoluteString ?? "")'")

        print("🚀 Request:")
        print(components.joined(separator: " \\\n\t"))
    }

    private func logResponse(data: Data, response: HTTPURLResponse) {
        guard isDebugLoggingEnabled else { return }

        print("\n📥 Response: HTTP \(response.statusCode)")

        if let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            print(prettyString)
        }

        print("\n")
    }
}
