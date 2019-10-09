//
//  NetworkDataFetcher.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 09.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol NetworkDataFetcherDelegate: class {
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, didFetch parsedXML: [XMLCurrency])
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, failedWith error: Error)
}

protocol NetworkDataFetcher {
    var delegate: NetworkDataFetcherDelegate? { get set }
    
    func fetchCurrencyInfoXML()
}

final class NetworkDataFetcherImplementation: NSObject, NetworkDataFetcher {
    
    static let shared = NetworkDataFetcherImplementation()
    
    private let networkService: NetworkService = NetworkServiceImplementation.shared
    
    private override init() {}
    
    weak var delegate: NetworkDataFetcherDelegate?
    
    func fetchCurrencyInfoXML() {
        networkService.getApiAnswerXML { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let parsedXML = try XMLParserHelper.shared.parseXMLIntoCurrency(xml: data)
                    strongSelf.delegate?.networkDataFetcher(strongSelf, didFetch: parsedXML)
                    
                } catch {
                    strongSelf.delegate?.networkDataFetcher(strongSelf, failedWith: error)
                    return
                }
                
            case .failure(let error):
                strongSelf.delegate?.networkDataFetcher(strongSelf, failedWith: error)
            }
        }
    }
}