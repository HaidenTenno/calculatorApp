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
        
        request(Config.apiURL, method: .get).validate().responseData { [weak self] response in
            
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
    
//    func getApiAnwer() {
//
//        //TEST
//        let parsedJson: ConverterApiAnswer
//
//        guard let filepath = Bundle.main.path(forResource: "dataToTest", ofType: "json")  else {
//            fatalError("Invalid bundle file")
//        }
//
//        do {
//            let contents = try String(contentsOfFile: filepath)
//
//            guard let data = contents.data(using: .utf8) else {
//                fatalError("Invalid bundle file")
//            }
//
//            parsedJson = try JSONDecoder().decode(ConverterApiAnswer.self, from: data)
//        } catch {
//            fatalError("Invalid bundle file")
//        }
//
//        delegate?.networkService(self, didReceive: parsedJson)
//        //TEST
//
//    }
    
}
