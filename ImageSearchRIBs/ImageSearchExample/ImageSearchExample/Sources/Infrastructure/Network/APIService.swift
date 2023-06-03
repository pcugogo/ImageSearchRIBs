//
//  APIService.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

struct APIService: APIServiceType {
    func request<T: Decodable>(api: API) -> Single<T> {
        return Single.create { single in
            api.dataRequest()
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let response):
                        single(.success(response))
                    case .failure(let error):
                        single(.failure(error.handling()))
                    }
                }
            return Disposables.create()
        }
    }
}

private extension AFError {
    func handling() -> NetworkError {
        var error: NetworkError?
        
        if case .responseSerializationFailed(let reason) = self {
            #if DEBUG
            print("decoding error reason: \(reason)")
            #endif
            error = .unknown
        }
        
        if let underlyingError = underlyingError,
           let urlError = underlyingError as? URLError {
            error = NetworkError(rawValue: urlError.code.rawValue)
        }
        
        if let responseCode = responseCode {
            error = NetworkError(rawValue: responseCode)
        }
        
        return error ?? .unknown
    }
}
