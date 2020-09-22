//
//  Student.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 20/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import Foundation

struct Student: Decodable {
  let id: Int
  let name: String
  let school_id: Int
  let grade: Int

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case school_id
    case grade
  }
}
