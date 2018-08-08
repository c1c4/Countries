//
//  country.swift
//  countries
//
//  Created by Felipe Arado Pompeu on 07/08/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

import Foundation

struct Country : Codable {
    var name: String
    var currencies : [[String:String?]]
    var languages : [[String:String?]]
}
