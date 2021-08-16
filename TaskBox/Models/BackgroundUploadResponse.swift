//
//  BackgroundUploadResponse.swift
//  TaskBox
//
//  Created by Vyacheslav on 20.05.2021.
//

import Foundation

struct BackgroundUploadResponse: Decodable {
    var error: String?
    var bgTh: String?
}
