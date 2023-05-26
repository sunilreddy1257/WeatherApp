//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Sunil Kumar Reddy Sanepalli on 26/05/23.
//

import Foundation
import Combine

//@Usage: This class used for getting weather related apis data
class WeatherService {
    static var shared = WeatherService()
    private init() {}
    
    private var cancellables = Set<AnyCancellable>()
    
    func getData<T: Decodable>(url: String, type: T.Type) -> Future<[T], Error> {
        return Future<[T], Error> { [weak self] promise in
            guard let url = URL(string: url) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let responseData = response as? HTTPURLResponse, 200...299 ~= responseData.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let error as DecodingError:
                            promise(.failure(error))
                        default:
                            promise(.failure(NetworkError.decodingError))
                        }
                    }
                } receiveValue: { decodeData in
                    promise(.success(decodeData))
                }
                .store(in: &self!.cancellables)
        }
    }
    
    func getDetails<T: Decodable>(url: String, type: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let url = URL(string: url) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let responseData = response as? HTTPURLResponse, 200...299 ~= responseData.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let error as DecodingError:
                            promise(.failure(error))
                        default:
                            promise(.failure(NetworkError.decodingError))
                        }
                    }
                } receiveValue: { decodeData in
                    promise(.success(decodeData))
                }
                .store(in: &self!.cancellables)
        }
    }
}

