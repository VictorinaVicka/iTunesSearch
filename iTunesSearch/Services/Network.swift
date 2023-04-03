//
//  Network.swift
//  iTunesSearch
//
//  Created by Victoria Vorobyova on 26.03.2023.
//

import Foundation
import Combine

enum NetworkServiceError: Error {
    case commonError
}

protocol NetworkServiceDelegat {
    func request(component: Component) -> AnyPublisher<Data, Error>
}

class NetworkService: NetworkServiceDelegat {

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func request(component: Component) -> AnyPublisher<Data, Error> {
        guard let url = component.url else {
            return Fail<Data, Error>(error: NetworkServiceError.commonError)
                .eraseToAnyPublisher()
        }

        var urlRequest = URLRequest(url: url)

        component.headers.forEach {
            urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
        }

        return urlSession.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
