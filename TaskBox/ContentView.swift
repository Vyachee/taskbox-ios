//
//  ContentView.swift
//  TestApp1
//
//  Created by Vyacheslav on 11.05.2021.
//

import SwiftUI
import URLImage


struct ContentView: View {
    
    @State var isAuthDone = false
    
    init() {
        let authData = CacheHelper().getAuthData()
        if(authData != nil) {
            _isAuthDone = State(initialValue: true)
        }
        
    }
    
    var body: some View {
        
        if(isAuthDone) {
            MainScreen(isAuthDone: $isAuthDone)
        }   else {
            AuthScreen(isAuthDone: $isAuthDone)
        }
        
    }
}

struct MainScreen: View {
    
    @Binding var isAuthDone: Bool
    @State var user: User = User()
    @State var bgUrl = ""
    @State var lastBgUrl = ""
    @ObservedObject var items: BtnStore = BtnStore()
    
    @State var uiimage: UIImage?
    
    
    init(isAuthDone: Binding<Bool>) {
        _isAuthDone = isAuthDone
        
        
        let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithOpaqueBackground()
            coloredAppearance.backgroundColor = UIColor.init(red: 0.12, green: 0.13, blue: 0.29, alpha: 1)
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        
        UIToolbar.appearance().tintColor = UIColor.init(red: 0.12, green: 0.13, blue: 0.29, alpha: 1)
    }
    
    

    
    var body: some View {
        
        
        
        NavigationView {
            
            ZStack {
                
                HStack {

                }.onChange(of: bgUrl, perform: { value in
                    
                })
                
                if uiimage == nil {
                    if !bgUrl.isEmpty {
                        URLImage(URL(string: "https://task-box.ru/i/backgrounds/\(bgUrl)?\(NSDate().timeIntervalSince1970)")!) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .onAppear {
                                    uiimage = image.asUIImage()
                                }
                        }
                    }
                }   else {
                    Image(uiImage: uiimage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: UIScreen.main.bounds.size.width)
                }
                
                HStack {
                    
                }
                
                
                
                VStack {
                    
                    HStack {
                        
                    }
                    
                    ScrollView {
                        
                        Cams(camsList: user.Cams)
                        
                        
                        Buttons(buttonsList: items)
                        
                    }
                }
                .onChange(of: user.userBG, perform: { value in
                    print("changed")
                })
                
                .padding(.top)
                .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        
                        NavigationLink(destination: SettingsScreen(user: $user, mainBg: $uiimage)) {
                            Image(systemName: "gear")
                        }
                        
                        Button{
                            CacheHelper().clearAuthData()
                            isAuthDone = false
                        } label: {
                            Image(systemName: "lock")
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        HStack {
                            VStack {
                                if (user.userPhoto != nil && !user.userPhoto!.isEmpty) {
                                    URLImage(URL(string: "https://task-box.ru/i/avatars/\(user.userPhoto!)?\(NSDate().timeIntervalSince1970)" )!) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 38)
                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                    }
                                }   else {
                                    Image("nophoto").resizable().scaledToFit().frame(width: 38)
                                }
                                
                            }
                            .padding(.leading)
                            VStack {
                                if let fio = self.user.fio {
                                    Text("Добро пожаловать \n\(fio)")
                                        .foregroundColor(Color.white)
                                }   else {
                                    Text("Загрузка...")
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.size.width)
            
            .onAppear() {
                print("appear")
                if user.fio == nil {
                    let authData = CacheHelper().getAuthData()!
                    ApiHelper().getUserInfo(authData: authData) { r in
                        
                        user = r
                        if let bg = user.userBG {
                            bgUrl = bg
                        }
                        
                        items.items = user.Buttons
                        
                        
                    }
                }
            }
            .onDisappear {
                print("disappear")
            }
        }.accentColor(.white)
        
        
    }
}

class HostingController<ContentView>: UIHostingController<ContentView> where ContentView : View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

struct AuthScreen: View {
    
    @State private var login = ""
    @State private var password = ""
    @State private var errorAlertShowing = false
    @State private var incorrectAuthDataAlert = false
    @Binding var isAuthDone: Bool
    
    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, idealWidth: 100, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: .infinity, alignment: .center)
                    
            
            VStack {
                HStack {
                    Spacer()
                    Image("newlogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding()
                    Spacer()
                }.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                VStack {
                    TextField("Логин", text: $login)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                    SecureField("Пароль", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                }.padding()
                
                
                
                Button("Войти в учетную запись") {
                    
                    if (login.isEmpty || password.isEmpty) {
                        self.errorAlertShowing = true
                    }   else {
                        let authData = AuthData(l: login, p: password)
                        ApiHelper().auth(
                            authData: authData
                        ) { status in
                            if status {
                                CacheHelper().writeAuthData(authData: authData)
                                isAuthDone = true
                            }   else {
                                incorrectAuthDataAlert = true
                            }
                        }
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(20)
                .foregroundColor(Color.white)
                .padding()
                .alert(isPresented: $errorAlertShowing) {
                    Alert(title: Text("Ошибка"), message: Text("Заполните все поля"))
                }
                .alert(isPresented: $incorrectAuthDataAlert, content: {
                    Alert(title: Text("Ошибка"), message: Text("Неверный логин или пароль"))
                })
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

