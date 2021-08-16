//
//  Btn.swift
//  TestApp1
//
//  Created by Vyacheslav on 14.05.2021.
//

import Foundation

struct Btn: Decodable, Identifiable {
    
    var id: UUID? = UUID()
    var doorID: String?
    var doorName: String?
    var doorValue: String?
    var doorIcon: String?
}

class BtnStore: ObservableObject {
    
    @Published var items: [Btn] = [Btn]()
}
