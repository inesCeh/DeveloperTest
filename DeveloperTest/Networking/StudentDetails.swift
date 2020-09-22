//
//  StudentDetails.swift
//  DeveloperTest
//
//  Created by Ines Ceh on 20/09/2020.
//  Copyright © 2020 Ines Ceh. All rights reserved.
//

import Foundation

struct StudentDetails: Decodable {
  let id: Int
  let description: String

  enum CodingKeys: String, CodingKey {
    case id
    case description
  }
}
