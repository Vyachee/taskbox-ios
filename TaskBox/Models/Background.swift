//
//  Background.swift
//  TaskBox
//
//  Created by Vyacheslav on 19.05.2021.
//

import Foundation

struct Background: Decodable, Identifiable {
    var id: UUID? = UUID()
    var img_name: String?
}
