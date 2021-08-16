//
//  CacheHelper.swift
//  TestApp1
//
//  Created by Vyacheslav on 14.05.2021.
//

import Foundation

struct CacheHelper {
    
    public func writeAuthData(authData: AuthData) {
        
        let prefs = UserDefaults.standard
        prefs.setValue(authData.l, forKey: "login")
        prefs.setValue(authData.p, forKey: "password")
        prefs.synchronize()
        
    }
    
    public func clearAuthData() {
        let prefs = UserDefaults.standard
        prefs.removeObject(forKey: "login")
        prefs.removeObject(forKey: "password")
        prefs.synchronize()
    }
    
    public func getAuthData() -> AuthData? {
        
        let prefs = UserDefaults.standard
       
        if (prefs.object(forKey: "login") == nil || prefs.object(forKey: "password") == nil) {
            return nil
        } else {
            
            var l: String = ""
            var p: String = ""
            
            if let login = prefs.value(forKey: "login") {
                l = String(describing: login)
            }   else {
                return nil
            }
            
            if let password = prefs.value(forKey: "password") {
                p = String(describing: password)
            }
            
            return AuthData(l: l, p: p)
        }
        
    }
    
}
