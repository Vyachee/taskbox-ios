//
//  ApiHelper.swift
//  TestApp1
//
//  Created by Vyacheslav on 13.05.2021.
//

import Foundation
import Alamofire

struct ApiHelper {
    
    public func auth(authData: AuthData, completion: @escaping (Bool) -> Void) {
        
        let url = "https://task-box.ru/ultra/?cat=checkform"
        AF.request(url,
                   method: .post,
                   parameters: [
                    "l": authData.l,
                    "p": authData.p
                   ]).responseString { response in
                    
                    completion(response.value == "102")
        }
    }
    
    public func getUserInfo(authData: AuthData, completion: @escaping (User) -> Void) {
        
        let url = "https://task-box.ru/ultra/?cat=getuserinfo"
        AF.request(url,
                   method: .post,
                   parameters: [
                    "l": authData.l,
                    "p": authData.p
                   ]).responseString { response in
                    
                    if let r = response.value {
                        print(r)
                        let decoder = JSONDecoder()

                        do {
                            let user: User = try decoder.decode(User.self, from: Data(r.utf8))
                            completion(user)
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
        }
    }
    
    
    public func openDoor(id: String) {
        
        let url = "https://task-box.ru/ultra/?cat=opendoor&did=\(id)"
        
        AF.request(url).responseString { response in}
        
    }
    
    public func saveUserInfo(l: String, p: String, fio: String, office_name: String, tel: String, newPass: String, completion: @escaping (Bool) -> Void) {
            
        let url = "https://task-box.ru/ultra/?cat=saveinfo"
        
        AF.request(url,
                   method: .post,
                   parameters: [
                    "l": l,
                    "p": p,
                    "fio": fio,
                    "tel": tel,
                    "office_name": office_name,
                    "newPass": newPass
                   ]).responseString { response in
                    
                    if let r = response.value {
                        
                        if r == "101" {
                            completion(true)
                        }
                        
                    }
        }
        
        
    }
    
    func saveUserInfo(l: String, p: String, fio: String, office_name: String, tel: String, newPass: String, image: Data, completion: @escaping (Bool) -> Void) {
        
        let url = "https://task-box.ru/ultra/?cat=saveinfo"
        
        AF.upload(multipartFormData: { multiPart in
            
            multiPart.append(image, withName: "userPic", fileName: "file.jpg", mimeType: "image/jpg")
            multiPart.append(l.data(using: String.Encoding.utf8)!, withName : "l")
            multiPart.append(p.data(using: String.Encoding.utf8)!, withName : "p")
            multiPart.append(fio.data(using: String.Encoding.utf8)!, withName : "fio")
            multiPart.append(office_name.data(using: String.Encoding.utf8)!, withName : "office_name")
            multiPart.append(tel.data(using: String.Encoding.utf8)!, withName : "tel")
            multiPart.append(newPass.data(using: String.Encoding.utf8)!, withName : "newPass")
                
        }, to: URL(string: url)!, usingThreshold: 1, method: .post, headers: nil, interceptor: nil, fileManager: FileManager(), requestModifier: nil)
        
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        
        .responseJSON(completionHandler: { data in
            CacheHelper().writeAuthData(authData: AuthData(l: l, p: newPass))
            if(String(describing: data.value) == "101") {
                completion(true)
            }
        })
        
    }
    
    func getBackgrounds(authData: AuthData, completion: @escaping (Backgrounds) -> Void) {
        let url = "https://task-box.ru/ultra/?cat=getMyBackgrounds"
        AF.request(url,
                   method: .post,
                   parameters: [
                    "l": authData.l,
                    "p": authData.p
                   ]).responseString { response in
                    
                    if let r = response.value {
                        let decoder = JSONDecoder()

                        do {
                            let backgrounds: Backgrounds = try decoder.decode(Backgrounds.self, from: Data(r.utf8))
                            completion(backgrounds)
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
        }
    }
    
    func setBackground(authData: AuthData, filename: String, completion: @escaping () -> Void) {
        
        let url = "https://task-box.ru/ultra/?cat=setBG"
        
        AF.request(url,
                   method: .post,
                   parameters: [
                    "l": authData.l!,
                    "p": authData.p!,
                    "background": filename
                   ]).responseString { response in
                    
                        completion()
        }
        
    }
    
    func uploadBackground(l: String, p: String, image: Data, completion: @escaping (String) -> Void) {
        
        let url = "https://task-box.ru/ultra/?cat=uploadBG"
        
        AF.upload(multipartFormData: { multiPart in
            
            multiPart.append(image, withName: "userBG", fileName: "file.jpg", mimeType: "image/jpg")
            multiPart.append(l.data(using: String.Encoding.utf8)!, withName : "l")
            multiPart.append(p.data(using: String.Encoding.utf8)!, withName : "p")
                
        }, to: URL(string: url)!, usingThreshold: 1, method: .post, headers: nil, interceptor: nil, fileManager: FileManager(), requestModifier: nil)
        
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        
        .responseString(completionHandler: { data in
            
            if let r = data.value {
                let decoder = JSONDecoder()

                do {
                    let backgrounds: BackgroundUploadResponse = try decoder.decode(BackgroundUploadResponse.self, from: Data(r.utf8))
                    if let full_url = backgrounds.bgTh {
                        let short = full_url.replacingOccurrences(of: "http://task-box.ru/i/backgrounds/th_", with: "")
                        completion(short)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        })
        
    }
}

struct AuthData: Encodable {
    let l: String?
    let p: String?
}
