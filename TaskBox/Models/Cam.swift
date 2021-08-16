//
//  Cam.swift
//  TestApp1
//
//  Created by Vyacheslav on 14.05.2021.
//

import Foundation

struct Cam: Decodable, Equatable, Identifiable{
    var id: UUID? = UUID()
    var camID: String?
    var cam_name: String?
    var cam_URL: String?
    var cam_MStream: String?
    var camType: String?
}
