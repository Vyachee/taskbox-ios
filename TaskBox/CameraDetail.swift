//
//  CameraDetail.swift
//  TestApp1
//
//  Created by Vyacheslav on 17.05.2021.
//

import SwiftUI
import MobileVLCKit

struct CameraDetail: View {
    
    var camera: Cam?
    @State var date = Date()
    @State var value: Float = 0
    
    @State var selectedDate = ""
    @State var changed = false
    
    @State var lastDate = ""
    @State var isPlayerRemoved = false
    
    
    
    var body: some View {
        VStack {
            
            VStack {
                
            }.onChange(of: selectedDate, perform: { value in
                lastDate = selectedDate
            })
            .onChange(of: date, perform: { value in
                getSelectedDate()
            })
            
            if !isPlayerRemoved {
                if lastDate != selectedDate {
                    if(camera!.camType! == "reg") {
                        VlcPlayerDemo(url: "\(camera!.cam_URL!)?starttime=\($selectedDate.wrappedValue)", isPreview: false)
                            .frame(width: 350, height: 200)
                            .cornerRadius(10)
                            .padding()
                    }   else {
                        
                        VlcPlayerDemo(url: "\(camera!.cam_MStream!)", isPreview: false)
                            .frame(width: 350, height: 200)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
            
            
            
            
            if(camera!.camType! == "reg") {
                VStack {
                    DatePicker("Дата просмотра", selection: $date, in: ...Date(), displayedComponents: [.date])

                    HStack {
                        Slider(value: $value, in: 1...86399, onEditingChanged: {val in
                            getSelectedDate()
                        })
                        Text("\(Int(value) / 3600):\((Int(value) % 3600) / 60):\((Int(value) % 3600) % 60)")
                            .frame(width: 100)
                        
                    }
                }.padding()
            }
            
        }
//        .navigationTitle(camera!.cam_name!)
        .onAppear {
            getSelectedDate()
        }
        .onDisappear() {
            isPlayerRemoved = true
        }
        
        
    }
    public func getSelectedDate() {
        let sDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(value))
        
        var (sh, sm, ss) = ("", "", "")
        
        if h < 10 {
            sh = "0\(h)"
        }   else {
            sh = "\(h)"
        }
        
        if m < 10 {
            sm = "0\(m)"
        }   else {
            sm = "\(m)"
        }
        
        if s < 10 {
            ss = "0\(s)"
        }   else {
            ss = "\(s)"
        }
        
        var (syear, smonth, sday) = ("\(sDate.year!)", "", "")
        
        if sDate.month! < 10 {
            smonth = "0\(sDate.month!)"
        }   else {
            smonth = "\(sDate.month!)"
        }
        
        if sDate.day! < 10 {
            sday = "0\(sDate.day!)"
        }   else {
            sday = "\(sDate.day!)"
        }
        
        selectedDate = "\(syear)\(smonth)\(sday)"
        selectedDate += "T\(sh)\(sm)\(ss)Z"
        print(selectedDate)
    }
    
    func secondsToHoursMinutesSeconds (seconds: Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

struct CameraDetail_Previews: PreviewProvider {
    static var previews: some View {
        CameraDetail()
    }
}
