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
    case serverError
    case receiveDataError
    case parseError
}

protocol NetworkServiceDelegate: class {
    func networkService(_ networkService: NetworkService, didReceive answer: ConverterApiAnswer)
    func networkService(_ networkService: NetworkService, didReceive error: NetworkServiceError)
}

extension NetworkServiceDelegate {
    
    func networkService(_ networkService: NetworkService, didReceive answer: ConverterApiAnswer) {
        #if DEBUG
        print("GOT ANSWER: \(answer)")
        #endif
    }
    
    func networkService(_ networkService: NetworkService, didReceive error: NetworkServiceError) {
        #if DEBUG
        print("NETWORK ERROR: \(error)")
        #endif
    }
}

protocol NetworkService {
    
    var delegate: NetworkServiceDelegate? { get set }
    
    func getApiAnwer()
}

final class NetworkServiceImplementation: NetworkService {
    
    static let shared = NetworkServiceImplementation()
    
    private let sessionManager = Alamofire.SessionManager.default
    
    weak var delegate: NetworkServiceDelegate?
    
    //Проверка доступности интернет соединения
    private var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    private init() {}
    
    func getApiAnwer() {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, didReceive: .connectionError)
            return
        }
        
        request(Config.Networking.russianJSON, method: .get).validate().responseData { [weak self] response in
            guard let strongSelf = self else { return }

            guard response.result.isSuccess else {
                strongSelf.delegate?.networkService(strongSelf, didReceive: .receiveDataError)
                return
            }
            
            guard let data = response.result.value else {
                strongSelf.delegate?.networkService(strongSelf, didReceive: .receiveDataError)
                return
            }
            
            do {
                let parsedResponse = try JSONDecoder().decode(ConverterApiAnswer.self, from: data)
                strongSelf.delegate?.networkService(strongSelf, didReceive: parsedResponse)
            }
            catch {
                strongSelf.delegate?.networkService(strongSelf, didReceive: .parseError)
                return
            }
        }
    }
    
    func getApiAnswer(with completionHandler: @escaping (Swift.Result<Data, Error>) -> Void) {
        
        guard isConnectedToInternet else {
            delegate?.networkService(self, didReceive: .connectionError)
            return
        }
        
        guard let url = URL(string: Config.Networking.russianJSON) else { return }
    
        request(url, method: .get).validate().responseData { response in
            
            DispatchQueue.main.async {
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    // TODO : REMOVE
//    func getApiAnswerXML(with completionHandler: @escaping (Swift.Result<Data, Error>) -> Void) {
//
//        guard isConnectedToInternet else {
//            delegate?.networkService(self, didReceive: .connectionError)
//            return
//        }
//
//        guard let url = URL(string: Config.Networking.russianXML) else { return }
//
//        request(url, method: .get).validate().responseData { response in
//
//            DispatchQueue.main.async {
//                switch response.result {
//                case .success(let data):
//                    completionHandler(.success(data))
//                case .failure(let error):
//                    completionHandler(.failure(error))
//                }
//            }
//        }
//    }
}
