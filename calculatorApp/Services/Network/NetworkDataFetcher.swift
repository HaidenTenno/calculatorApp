//
//  NetworkDataFetcher.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 09.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol NetworkDataFetcherDelegate: class {
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, didFetch data: ConverterApiAnswer)
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, failedWith error: Error)
}

extension NetworkDataFetcherDelegate {
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, failedWith error: Error) {
        #if DEBUG
        print("Fetching data error: \(error.localizedDescription)")
        #endif
    }
}

protocol NetworkDataFetcher {
    var delegate: NetworkDataFetcherDelegate? { get set }
    
    func fetchCurrencyInfo()
}

final class NetworkDataFetcherImplementation: NetworkDataFetcher {
    
    static let shared = NetworkDataFetcherImplementation()
    
    private let networkService = NetworkServiceImplementation.shared
 
    private init() {}
    
    weak var delegate: NetworkDataFetcherDelegate?
    
    func fetchCurrencyInfo() {
        networkService.getApiAnswer { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let data):
                
                do {
                    let parsedResponse = try JSONDecoder().decode(ConverterApiAnswer.self, from: data)
                    strongSelf.delegate?.networkDataFetcher(strongSelf, didFetch: parsedResponse)
                }
                catch {
                    strongSelf.delegate?.networkDataFetcher(strongSelf, failedWith: error)
                    return
                }
                
            case .failure(let error):
                strongSelf.delegate?.networkDataFetcher(strongSelf, failedWith: error)
            }
        }
    }
    
}
