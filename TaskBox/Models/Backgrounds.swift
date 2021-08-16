//
//  Backgrounds.swift
//  TaskBox
//
//  Created by Vyacheslav on 19.05.2021.
//

import Foundation

struct Backgrounds: Decodable {
    var path: String?
    var images = [Background]()
}
