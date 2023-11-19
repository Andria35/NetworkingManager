// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

@available(iOS 13.0.0, *)
public class NetworkingManager {
        
    public init() {}
    
    func fetchData<T: Decodable>(fromURL urlString: String) async throws -> T? {
        
        guard let url = URL(string: urlString) else { throw GHError.invalidURL }
        
        // Perform the network request asynchronously
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        // Decode Data
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let object = try decoder.decode(T.self, from: data)
            return object
        } catch {
            throw GHError.invalidData
        }
    }
}


enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
