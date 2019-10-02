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
    case noResponce
}

protocol NetworkServiceDelegate: class {
    
}

protocol NetworkService {
    
    var delegate: NetworkServiceDelegate? { get set }
}

final class NetworkServiceImplementation: NetworkService {
    
    static let shared = NetworkServiceImplementation()
    
    weak var delegate: NetworkServiceDelegate?
    
    private init() {}
    
}
