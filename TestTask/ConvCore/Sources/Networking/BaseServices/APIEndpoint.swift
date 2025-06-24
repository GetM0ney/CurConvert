import Foundation

enum APIEndpoint {
    case latest(currencies: [Currency], base: Currency)
    case availableCurrencies(currencies: [Currency])
}

extension APIEndpoint: Endpoint {
    public var baseURL: String {
        "https://api.freecurrencyapi.com"
    }

    public var path: String {
        switch self {
        case .latest:
            return "/v1/latest"
        case .availableCurrencies:
            return "/v1/currencies"
        }
    }

    public var method: HTTPMethod {
        .get
    }

    public var queryItems: [URLQueryItem]? {
        var items: [URLQueryItem] = [
            URLQueryItem(name: "apikey", value: "fca_live_SSfeOaScFgUHqk63ps5N7ij2TRWOQFaIYKY4xoN7")
        ]

        switch self {
        case let .latest(currencies, base):
            items.append(URLQueryItem(
                name: "currencies",
                value: currencies.map(\.rawValue).joined(separator: ",")
            ))
            items.append(URLQueryItem(name: "base_currency", value: base.rawValue))

        case let .availableCurrencies(currencies):
            items.append(URLQueryItem(
                name: "currencies",
                value: currencies.map(\.rawValue).joined(separator: ",")
            ))
        }

        return items
    }
}
