//
//  Connectivity.swift
//  Contact Manager
//
//  Created by Vignesh on 03/05/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation

import Alamofire


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
