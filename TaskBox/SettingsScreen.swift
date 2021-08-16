//
//  SettingsScreen.swift
//  TestApp1
//
//  Created by Vyacheslav on 15.05.2021.
//

import SwiftUI
import URLImage

struct SettingsScreen: View {
    
    @Binding var user: User
    @Binding var mainBg: UIImage?
    
    @State var isPickerShow = false
    @State var image: UIImage?
    @State var fio: String = ""
    @State var office_name: String = ""
    @State var password: String = ""
    @State var phone: String = ""
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                
                if image == nil {
                    if let userPhoto = user.userPhoto {
                        URLImage(URL(string: "https://task-box.ru/i/avatars/\(userPhoto)?\(NSDate().timeIntervalSince1970)" )!) { i in
                            i
                                .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .frame(width: 150, height: 150)
                                
                                .onAppear {
                                    image = i.asUIImage()
                                }
                        }
                    }   else {
                        Image("nophoto")
                            .resizable()
                            .scaledToFit()
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .frame(width: 150, height: 150)
                    }
                }   else {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        .frame(width: 150, height: 150)
                }
                
                
                
                Button("Изменить фото") {
                    isPickerShow = true
                }.sheet(isPresented: $isPickerShow, content: {
                    
                    ImagePickerView(sourceType: UIImagePickerController.SourceType.photoLibrary) { UIImage in
                        image = UIImage
                    }
                })
                
                BackgroundList(mainBg: $mainBg)
//                BackgroundList()
                
                Form {
                    TextField("Фамилия Имя Отчество", text: $fio)
                    TextField("Название офиса", text: $office_name)
                    TextField("Смена пароля", text: $password)
                    TextField("Контакный телефон", text: $phone)
                }.frame(minHeight: 300)
                
                Button("Сохранить изменения") {
                    
                    let authData = CacheHelper().getAuthData()
                    
                    if image != nil {
                        ApiHelper().saveUserInfo(l: (authData?.l!)!, p: (authData?.p!)!, fio: fio, office_name: office_name, tel: phone, newPass: password, image: (image?.jpegData(compressionQuality: 1))!, completion: { boo in
                            if(boo) {
                                user.fio = fio
                                user.officeName = office_name
                                user.userTelephone = phone
                                print("done")
                            }
                            
                        })
                    }   else {
                        ApiHelper().saveUserInfo(l: (authData?.l!)!, p: (authData?.p!)!, fio: fio, office_name: office_name, tel: phone, newPass: password, completion: { boo in
                            if(boo) {
                                user.fio = fio
                                user.officeName = office_name
                                user.userTelephone = phone
                                print("done")
                            }
                        })
                    }
                    
                    
                    
                }.frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(20)
                .foregroundColor(Color.white)
                .padding()
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity)
            .onAppear {
                fio = user.fio!
                office_name = user.officeName!
                password = CacheHelper().getAuthData()!.p!
                phone = user.userTelephone!
                
            }
        }
        
    }
    
    public struct ImagePickerView: UIViewControllerRepresentable {
        
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
        @Environment(\.presentationMode) private var presentationMode
        
        public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
        
        public func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.sourceType = self.sourceType
            picker.delegate = context.coordinator
            return picker
        }
        
        public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        public func makeCoordinator() -> Coordinator {
            Coordinator(
                onDismiss: { self.presentationMode.wrappedValue.dismiss() },
                onImagePicked: self.onImagePicked
            )
        }
        
        final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            
            private let onDismiss: () -> Void
            private let onImagePicked: (UIImage) -> Void
            
            init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
                self.onDismiss = onDismiss
                self.onImagePicked = onImagePicked
            }
            
            public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let image = info[.originalImage] as? UIImage {
                    self.onImagePicked(image)
                }
                self.onDismiss()
            }
            
            public func imagePickerControllerDidCancel(_: UIImagePickerController) {
                self.onDismiss()
            }
            
        }
        
    }
    
}

//struct SettingsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsScreen()
//    }
//}
