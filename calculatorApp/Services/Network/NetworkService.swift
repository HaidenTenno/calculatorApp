//
//  NetworkService.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation
import Alamofire

enum NetworkServiceError: Error {
    case connectionError
    case receiveDataError(_ error: Error)
}

protocol NetworkService {
    func getApiAnswerXML(with completionHandler: @escaping (Swift.Result<Data, Error>) -> Void)
}

final class NetworkServiceImplementation: NetworkService {
    
    static let shared = NetworkServiceImplementation()
    
    private let sessionManager = Alamofire.SessionManager.default
    
    private var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    private init() {}
    
    func getApiAnswerXML(with completionHandler: @escaping (Swift.Result<Data, Error>) -> Void) {
        
        guard isConnectedToInternet else {
            completionHandler(.failure(NetworkServiceError.connectionError))
            return
        }
        
        guard let url = URL(string: Config.Networking.url) else { return }
        
        request(url, method: .get).validate().responseData { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    completionHandler(.failure(NetworkServiceError.receiveDataError(error)))
                }
            }
        }
    }
}
