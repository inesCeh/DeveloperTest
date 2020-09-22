//
//  Teacher.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 18/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import Foundation

//struct Teacher: Encodable {
//
//    let id: Int
//    let name: String
//    let school_id: Int
//    let className: String
//    let image_url: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case school_id
//        case className = "class"
//        case image_url
//    }
//
//    func encode(to encoder: Encoder) throws {
//      var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(school_id, forKey: .school_id)
//        try container.encode(className, forKey: .className)
//        try container.encode(image_url, forKey: .image_url)
//    }
//}
//

//extension Teacher: Decodable {
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//
//    id = try container.decode(Int.self, forKey: .id)
//    name = try container.decode(String.self, forKey: .name)
//    school_id = try container.decode(Int.self, forKey: .id)
//    className = try container.decode(String.self, forKey: .className)
//    image_url = try container.decode(String.self, forKey: .image_url)
//        //self = .iosApp(type, name, image, iosStore, iosDetails)
//  }
//}
    
    
struct Teacher: Decodable {
  let id: Int
  let name: String
  let school_id: Int
  let className: String
  let image_url: String

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case school_id
    case className = "class"
    case image_url
  }
}

  




