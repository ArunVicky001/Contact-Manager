//
//  UserContact.swift
//  Contact Manager
//
//  Created by Vignesh on 04/05/18.
//  Copyright © 2018 Vignesh. All rights reserved.
//

import Foundation


struct Address: Decodable {
    let Name: String
    let Phone: String
    let Email: String
    let Street: String
    let Company: String
    let City: String
    //    let Zip : NSNumber?
    let ID: Int
    let Age: Int
}
