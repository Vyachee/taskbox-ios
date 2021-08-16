//
//  Buttons.swift
//  TestApp1
//
//  Created by Vyacheslav on 14.05.2021.
//

import SwiftUI

struct Buttons: View {
    
    @ObservedObject var buttonsList: BtnStore = BtnStore()
    
    var body: some View {
        VStack {
            ForEach(buttonsList.items, id: \.doorID) { button in
                let color = button.doorValue! == "1" ? Color.orange : Color(red: 0.15, green: 0.17, blue: 0.39)
                Button{
                    ApiHelper().openDoor(id: button.doorID!)
                    for index in (0 ..< buttonsList.items.count) {
                        if(buttonsList.items[index].doorID == button.doorID) {
                            if buttonsList.items[index].doorValue == "1" {
                                
                                buttonsList.items[index].doorValue = "0"
                                
                            }   else {
                                
                                buttonsList.items[index].doorValue = "1"
                                
                            }
                        }
                    }
                    
                }
                label: {
                    HStack {
                        Image(button.doorIcon!).resizable().scaledToFit().frame(width: 32, height: 32)
                        Spacer()
                            .foregroundColor(Color.white)
                        Text(button.doorName!).foregroundColor(Color.white)
                        Spacer()
                        Image(systemName: ((button.doorValue! == "0") ? "lock": "lock.open"))
                            .resizable()
                            .scaledToFit()
                            .accentColor(.white)
                            .frame(width: 24, height: 24)
                        
                    }.frame(maxWidth: .infinity)
                    .background(color)
                    
                }
                .padding(.leading)
                .padding(.trailing)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(color)
                
            }
        }
        .cornerRadius(10)
        .padding()
    }
}

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        Buttons()
    }
}
