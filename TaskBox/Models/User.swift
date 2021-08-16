//
//  User.swift
//  TestApp1
//
//  Created by Vyacheslav on 14.05.2021.
//

import Foundation

struct User: Decodable {
    var userID: String?
    var fio: String?
    var userPhoto: String?
    var userBG: String?
    var officeName: String?
    var userTelephone: String?
    var userEmail: String?
    var Buttons = [Btn]()
    var Cams = [Cam]()
}
