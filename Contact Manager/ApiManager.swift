//
//  ApiManager.swift
//  Contact Manager
//
//  Created by Vignesh on 04/05/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {
    
    static let shareInstant = ApiManager() ; private init(){}
    
    enum ConnectionResult {
        case success(Data)
        case failure(Error)
    }
    
    func fetchUserDetails(urlString: String, userCount: [String: Int], completion: @escaping (ConnectionResult) -> ()) {
        Alamofire.request(urlString, parameters: userCount)
            .responseJSON { response in
                if response.result.isSuccess {
                    guard let result = response.data else { return }
                    print("success")
                    completion(.success(result))
                } else {
                    print("Error")
                    if let error = response.result.error{
                        completion(.failure(error))
                    }
                }
        }
    }
    
    
    
    
}
