//
//  SchoolDetails.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 20/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import Foundation

struct SchoolDetails: Decodable {
    let id: Int
    let name: String
    let image_url: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image_url
    }
}


