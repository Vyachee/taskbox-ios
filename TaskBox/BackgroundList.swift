//
//  BackgroundList.swift
//  TaskBox
//
//  Created by Vyacheslav on 20.05.2021.
//

import SwiftUI
import URLImage
import Combine
import Foundation

struct BackgroundList: View {
    
    @State var backgrounds: Backgrounds?
    @State var isPickerShow = false
    @State var loadedBackgrounds = [UIImage]()
    @Binding var mainBg: UIImage?
    @State var loaded = false
    
    @State var isAlertVisible = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Выбор фона")
                    .fontWeight(Font.Weight.semibold)
                    .font(Font.title)
                Spacer()
            }
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    
                    if let bgs = backgrounds?.images {
                        ForEach(bgs, id: \.img_name) { bg in
                            
                            
                            if let img_name = bg.img_name {
                                ImageView(withURL: "https://task-box.ru/i/backgrounds/\(img_name)?\(NSDate().timeIntervalSince1970)", bg: $mainBg, alert: $isAlertVisible)
                                    .onTapGesture {
                                        ApiHelper().setBackground(authData: CacheHelper().getAuthData()!, filename: img_name) {
                                            
                                        }
                                    }
//                                    .onTapGesture {
//                                        ApiHelper().setBackground(authData: CacheHelper().getAuthData()!, filename: img_name) {
//                                            mainBg = view.asUIImage()
//                                            isAlertVisible = true
//                                        }
//                                    }
                            }
                        }
                    }
                }
            }
            
            .alert(isPresented: $isAlertVisible) {
                Alert(title: Text("Успешно"), message: Text("Фон успешно установлен"), dismissButton: .default(Text("Отлично")) {
                    print(backgrounds)
                })
            }
            Button("Загрузить фоновое изображение") {
                isPickerShow = true
            }.sheet(isPresented: $isPickerShow, content: {
                
                SettingsScreen.ImagePickerView(sourceType: UIImagePickerController.SourceType.photoLibrary) { UIImage in
                    let authData = CacheHelper().getAuthData()!
                    ApiHelper().uploadBackground(l: authData.l!, p: authData.p!, image: UIImage.jpegData(compressionQuality: 1)!) { str in
                        
                        mainBg = UIImage
                        isAlertVisible = true
                        
                    }
                    //                    image = UIImage
                }
                
            })
            
        }
        .padding()
        .onAppear {
            ApiHelper().getBackgrounds(authData: CacheHelper().getAuthData()!) { bgs in
                backgrounds = bgs
            }
        }
    }
    
    class ImageLoader: ObservableObject {
        var didChange = PassthroughSubject<Data, Never>()
        var data = Data() {
            didSet {
                didChange.send(data)
            }
        }

        init(urlString:String) {
            guard let url = URL(string: urlString) else { return }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self.data = data
                }
            }
            task.resume()
        }
    }

    struct ImageView: View {
        @ObservedObject var imageLoader:ImageLoader
        @State var image:UIImage = UIImage()
        @Binding var bgg: UIImage?
        @Binding var alert: Bool
        
        init(withURL url:String, bg: Binding<UIImage?>, alert: Binding<Bool>) {
            imageLoader = ImageLoader(urlString:url)
            self._bgg = bg
            self._alert = alert
        }

        var body: some View {

                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:150, height:150)
                    .onReceive(imageLoader.didChange) { data in
                        self.image = UIImage(data: data) ?? UIImage()
                    }
                    .onTapGesture {
                        bgg = image
                        alert = true
                    }
        }
    }
}



extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}
//struct BackgroundList_Previews: PreviewProvider {
//    static var previews: some View {
//        BackgroundList()
//    }
//}
